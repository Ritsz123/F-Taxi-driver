import 'package:shared_preferences/shared_preferences.dart';
import 'package:uber_driver_app/globals.dart';

class HelperMethods {

  static late SharedPreferences _preferences;

  static Future<void> _initSharedPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }


  static Future<bool> cacheAuthToken(String token) async {
    await _initSharedPreferences();

    logger.i('Caching auth token');

    bool success = false;
    try {
      success = await _preferences.setString('authToken', token);
    } catch(e) {
      logger.e(e);
      throw Exception('unable to cache token');
    }
    logger.i('Auth token cache success');
    return success;
  }

  static Future<String> getAccessToken() async {
    await _initSharedPreferences();

    logger.i('getting cached auth token');

    String? token;
    try {
      token = _preferences.getString('authToken');
    } catch(e) {
      logger.e(e);
      throw Exception('unable to retrieve token');
    }
    if(token == null) {
      logger.e('Token not found');
      throw Exception('Token not found');
    }
    logger.i('access token retrieve success');
    return token;
  }

}