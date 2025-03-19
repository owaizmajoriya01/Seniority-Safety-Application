import 'package:shared_preferences/shared_preferences.dart';


///utility class that exposes SharedPreference which can be accessed without using await.
///
/// eg. [AppPreferenceUtil.instance]
class AppPreferenceUtil {
  static late final SharedPreferences instance;

  static Future<SharedPreferences> init({SharedPreferences? pref}) async =>
      instance = pref ?? await SharedPreferences.getInstance();

  //used to get String from shared preference without await .
  static String getString(String key, [String? defValue]) {
    var result = instance.get(key);
    if (result == null) {
      return defValue ?? "";
    } else {
      return result.toString();
    }
  }

  static Future<bool> setString(String key, String value) async {
    var prefs = instance;
    return prefs.setString(key, value);
  }

  static T? getValue<T>(String key, [T? defValue]) {
    ///is it safe to use instance.get(key) instead of using switch?

    switch (T) {
      case String:
        return ((instance.getString(key)) as T?) ?? defValue;
      case bool:
        return ((instance.getBool(key)) as T?) ?? defValue;
      case double:
        return ((instance.getDouble(key)) as T?) ?? defValue;
      case int:
        return ((instance.getInt(key)) as T?) ?? defValue;
      default:
        return null;
    }
  }

  static Future<bool> setValue<T>(String key, T value) {
    switch (T) {
      case String:
        return instance.setString(key, value as String);
      case bool:
        return instance.setBool(key, value as bool);
      case double:
        return instance.setDouble(key, value as double);
      case int:
        return instance.setInt(key, value as int);
      default:
        return Future.value(false);
    }
  }
}


class SharedPreferencesKey {
  static const isLoggedIn = "shared_is_logged_in";
  static const accessToken = "shared_access_token";
  static const userId = "shared_user_id";
  static const userName = "shared_user_name";
  static const userEmail = "shared_user_email";
  static const userPhone = "shared_user_phone";
  static const avatarOriginal = "shared_avatar_original";
  static const userType = "shared_user_type";
  static const latLngTimeStamp = "shared_lat_lng_timestamp";
  static const fcmToken = "fcm_token";
  static const userModel = "user_model";
}

