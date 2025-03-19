/*
import 'dart:async';

import 'package:elderly_care/models/my_user.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils/in_app_notification.dart';
import '../utils/location_utils.dart';
import '../widgets/appbar.dart';
import '../widgets/image_widget.dart';
import '../widgets/in_app_notification_widget.dart';
import '../widgets/ripple_effect_widget.dart';

class DistanceScreen extends StatefulWidget {
  const DistanceScreen({Key? key, this.userInfo}) : super(key: key);
  final MyUser? userInfo;

  @override
  State<DistanceScreen> createState() => _DistanceScreenState();
}

class _DistanceScreenState extends State<DistanceScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng sourceLocation = LatLng(37.3229322, -122.0551267);
  late final LatLng destination;
  Stream<Position>? _positionStream;

  //distance between retailer and sales person
  double _distance = 0;

  @override
  void initState() {
    super.initState();
    if (widget.userInfo != null &&
        widget.userInfo!.lastLat != null &&
        widget.userInfo!.lastLong != null) {
      destination = LatLng(widget.userInfo!.lastLat!.toDouble(),
          widget.userInfo!.lastLong!.toDouble());
    }
    _initPositionStream();
  }

  _initPositionStream() async {
    var permissionResult = await LocationUtils().checkAndRequestPermission();
    if (permissionResult == LocationPermission.whileInUse ||
        permissionResult == LocationPermission.always) {
      const LocationSettings locationSettings =
          LocationSettings(accuracy: LocationAccuracy.best, distanceFilter: 1);
      _positionStream =
          Geolocator.getPositionStream(locationSettings: locationSettings);
      setState(() {});
    } else {
      InAppNotification.show(context,
          title: "Missing Permission",
          subtitle:
              "Location permission is denied. Please enable location permission to continue",
          notificationType: NotificationType.error);
    }

    _controller.future.then(
        (value) => value.animateCamera(CameraUpdate.newLatLng(destination)));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const MyAppBar(
          title: "Elders",
          centerTitle: true,
        ),
        body: SizedBox.expand(
          child: StreamBuilder<Position>(
              stream: _positionStream,
              builder: (context, snapshot) {
                debugPrint(
                    'Debug _DistanceScreenState.build : ${snapshot.data} ');

                bool isInRange = _isWithin(25, snapshot.data, destination);
                return Column(
                  children: [
                    Expanded(
                      child: GoogleMap(
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        initialCameraPosition: const CameraPosition(
                          target: sourceLocation,
                          zoom: 13.5,
                        ),
                        markers: <Marker>{
                          */
/* const Marker(
                            markerId: MarkerId("source"),
                            position: sourceLocation,
                          ),*//*

                          Marker(
                            markerId: const MarkerId("destination"),
                            infoWindow: const InfoWindow(
                                title: "Shop name", snippet: "Retailer name"),
                            position: destination,
                          ),
                        },
                        circles: {
                          Circle(
                              circleId: const CircleId("destination"),
                              center: destination,
                              radius: 25,
                              fillColor: _fillColor(isInRange),
                              strokeWidth: 2,
                              strokeColor: _strokeColor(isInRange))
                        },
                        onMapCreated: (mapController) {
                          _controller.complete(mapController);
                        },
                      ),
                    ),
                    _DistanceInfo(
                      profileImageUrl: null,
                      shopName: widget.userInfo?.name ?? "-",
                      distanceInMeters: _distance,
                      onLocationTap: () {
                        _controller.future.then((value) => value.animateCamera(
                            CameraUpdate.newLatLngZoom(destination, 18)));
                      },
                    )
                  ],
                );
                */
/*else {
                  return const LoadingDialogBody(message: "Loading...");
                }*//*

              }),
        ),
      ),
    );
  }

  Color _fillColor(bool isInRange) {
    return isInRange ? const Color(0x3365e3c1) : const Color(0x3365c1e3);
  }

  Color _strokeColor(bool isInRange) {
    return isInRange ? Colors.green : Colors.blue;
  }

  bool _isWithin(double meter, Position? source, LatLng? destination) {
    if (source == null || destination == null) {
      return false;
    }

    double result = Geolocator.distanceBetween(source.latitude,
        source.longitude, destination.latitude, destination.longitude);
    _distance = result;
    return result <= meter;
  }
}

class _DistanceInfo extends StatelessWidget {
  const _DistanceInfo(
      {Key? key,
      this.profileImageUrl,
      required this.shopName,
      required this.distanceInMeters,
      required this.onLocationTap})
      : super(key: key);
  final String? profileImageUrl;
  final String shopName;
  final double distanceInMeters;
  final VoidCallback onLocationTap;

  String get _formattedDistance {
    if (distanceInMeters > 1000) {
      var distance = distanceInMeters / 1000;
      return "${distance.toStringAsFixed(2)} Km";
    } else {
      return "$distanceInMeters m";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          children: [
            ProfileImage(
              url: profileImageUrl,
              name: shopName,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shopName,
                      maxLines: 2,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(_formattedDistance,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
            MyRippleEffectWidget(
                onTap: onLocationTap,
                child: const Text(
                  "Locate\nRetailer",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                )),
          ],
        ));
  }
}
*/
