import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../widgets/dialogs.dart';


class LocationUtils {
  Future<Position?> getLocation() async {
    return _determinePosition();
  }

  Future<List<Location>> coordinatesFromAddress(String address) async {
    return await locationFromAddress(address);
  }

  Future<List<Placemark>> locationFromCoordinates(double lat, double long) async {
    return await placemarkFromCoordinates(lat, long);
  }

  /// checks and request for permission. if permissions are denied show dialog which opens app setting.
  Future<LocationPermission?> handlePermissionWithDialog(BuildContext context) async {
    final result = await _handlePermission().onError((error, stackTrace) {
      debugPrint('Debug LocationUtils.handlePermissionWithDialog : $error ');
    });

    _handleShowDialog(context, result);
    return result;
  }

  Future<LocationPermission?> checkAndRequestPermission() async {
    final result = await _handlePermission().onError((error, stackTrace) => null);
    return result;
  }

  //enable gps if its is disabled
  Future<bool> enableLocationService() async {
    await checkAndRequestPermission();
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      //await Geolocator.openAppSettings();
      //await Geolocator.openLocationSettings();
      await Geolocator.getCurrentPosition();
      return await Geolocator.isLocationServiceEnabled();
      //return Future.error('Location services are disabled.');
    }
    return serviceEnabled;
  }

  Future<Position?> _bgLocation() async {
    final permission = await _handlePermission().onError((error, stackTrace) => null);

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      return await Geolocator.getCurrentPosition();
    } else {
      return null;
    }
  }

  Future<Position?> _determinePosition() async {
    final permission = await _handlePermission().onError((error, stack) => null);

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      return await Geolocator.getCurrentPosition();
    } else {
      return await Geolocator.getLastKnownPosition();
    }
  }

  /// this method checks for location permissions and checks if location service is enabled.
  ///
  ///if location permissions are denied then request for permission.
  ///
  ///this method may throw future exception;
  Future<LocationPermission?> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      /* if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }*/
    }

    /* if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }*/
/*
///always Location permission
    if (permission == LocationPermission.whileInUse) {
      permission = await Geolocator.requestPermission();
      */ /*if (permission == LocationPermission.whileInUse) {
        return Future.error('Always Location permissions denied');
      }*/ /*
    }*/

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      try {
        await Geolocator.getCurrentPosition();
      } catch (e) {
        return null;
        //return Future.error("Location Service is not enabled.Please Enable Gps.");
      }
    }
    return permission;
  }

  bool hasPermission(LocationPermission? permission) {
    if (permission == null) {
      return false;
    }
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  ///checks if [source] is within [meter] radius of [destination]
  bool isWithinRange(double meter, double? sourceLat, double? sourceLong, double? destinationLat,
      double? destinationLong) {
    if (sourceLat == null || sourceLong == null || destinationLat == null || destinationLong == null) {
      return false;
    }

    double result = Geolocator.distanceBetween(sourceLat, sourceLong, destinationLat, destinationLong);
    return result <= meter;
  }

  void _handleShowDialog(BuildContext context, LocationPermission? permission) {
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      return;
    }
    showDialog(
        context: context,
        builder: (ctx) =>
            InfoDialog2(
              header: "Permissions",
              message: _dialogMessage(permission),
              onTap: () async {
                _onDialogTap(permission);
                Navigator.pop(ctx);
              },
            ));
  }

  void _onDialogTap(LocationPermission? permission) {
    switch (permission) {
      case LocationPermission.denied:
      case LocationPermission.deniedForever:
        Geolocator.openAppSettings();
        break;

      case LocationPermission.always:
      case LocationPermission.unableToDetermine:
      case LocationPermission.whileInUse:
      default:
        break;
        Geolocator.openLocationSettings();
        break;
    }
  }

  String _dialogMessage(LocationPermission? permission) {
    switch (permission) {
      case LocationPermission.denied:
        return "Location permissions are denied";
      case LocationPermission.deniedForever:
        return "Location permissions are permanently denied.";
    //case LocationPermission.whileInUse:
    //  return "Always Location permissions denied";
      case LocationPermission.whileInUse:
      case LocationPermission.always:
      case LocationPermission.unableToDetermine:
        return "";
      default:
        return "Location Service is not enabled.Please Enable Gps.";
    }
  }
}