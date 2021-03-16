import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ccu_toolbox/environments/app_info.dart' as appInfo;

class SharedPreferencesHelper {
  static Future<void> versionChecker() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    const int compatibleVersion =
        20210201; // Oldest build version can be supported

    // Clean incompatible version data and set vertion to current value
    if (prefs.containsKey('buildVersion')) {
      if (prefs.getInt('buildVersion') < compatibleVersion) {
        await prefs.clear();
        await prefs.setInt('buildVersion', appInfo.buildVersion);
      } else if (prefs.getInt('buildVersion') != appInfo.buildVersion) {
        await prefs.setInt('buildVersion', appInfo.buildVersion);
      }
    } else {
      await prefs.clear();
      await prefs.setInt('buildVersion', appInfo.buildVersion);
    }
  }
}
