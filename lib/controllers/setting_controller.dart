import 'package:shared_preferences/shared_preferences.dart';
import 'package:ccu_toolbox/helper/shared_preferences_helper.dart';
import 'package:ccu_toolbox/helper/database_helper.dart';

enum AppTheme {
  system,
  light,
  dark,
}

class SettingController {
  static Future<String> getAccountUsername() async {
    await SharedPreferencesHelper.versionChecker();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String username = prefs.getString('username') ?? '';

    return username;
  }

  static Future<void> deleteAccount() async {
    await SharedPreferencesHelper.versionChecker();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove('username');
    await prefs.remove('password');
  }

  static Future<AppTheme> getAppTheme() async {
    await SharedPreferencesHelper.versionChecker();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return AppTheme.values[prefs.getInt('theme') ?? 0];
  }

  static Future<void> setAppTheme(AppTheme theme) async {
    await SharedPreferencesHelper.versionChecker();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt('theme', theme.index);
  }

  static Future<void> clearCourseDatabase() async {
    await DatabaseHelper.deleteAllData('courses');
  }
}
