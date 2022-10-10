import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String loggedInKey = 'LOGGEDINKEY';
  static String userNameKey = 'USERNAMEKEY';
  static String userEmailKey = 'EMAILKEY';
  static String setPasscodeKey = 'SETPASSCODEKEY';
  static String passcodeKey = 'PASSCODEKEY';

  static Future<bool> saveUserLoggedinStatus(bool isUserloggedin) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(loggedInKey, isUserloggedin);
  }

  static Future<bool> saveUsername(String username) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, username);
  }

  static Future<bool> saveUserEmail(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  static Future<bool> savePasscodeStatus(bool isPasscodeSet) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(setPasscodeKey, isPasscodeSet);
  }

  static Future<bool> savedPasscode(String savedPasscode) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(passcodeKey, savedPasscode);
  }

  static Future<bool?> getUserLoggedinStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(loggedInKey);
  }

  static Future<String?> getUserName() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }

  static Future<String?> getUserEmail() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  static Future<bool?> getSavedPasscodeStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(setPasscodeKey);
  }

  static Future<String?> getSavedPasscode() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(passcodeKey);
  }
}
