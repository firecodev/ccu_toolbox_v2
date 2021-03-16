import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ccu_toolbox/helper/shared_preferences_helper.dart';
import 'package:ccu_toolbox/themes/light_theme.dart';
import 'package:ccu_toolbox/themes/dark_theme.dart';
import 'package:ccu_toolbox/screens/home_screen.dart';
import 'package:ccu_toolbox/screens/ecourse2_home_screen.dart';
import 'package:ccu_toolbox/screens/timetable_screen.dart';
import 'package:ccu_toolbox/screens/grade_screen.dart';
import 'package:ccu_toolbox/screens/transport_screen.dart';
import 'package:ccu_toolbox/screens/setting_screen.dart';
import 'package:ccu_toolbox/screens/schedule_screen.dart';
import 'screens/about_screen.dart';
import 'package:ccu_toolbox/screens/login_screen.dart';
import 'package:ccu_toolbox/screens/course_set_attendance_screen.dart';
import 'widgets/slide_page_transition.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper.versionChecker();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  ThemeMode themeMode = ThemeMode.values[prefs.getInt('theme') ?? 0];
  runApp(MainApp(themeMode: themeMode));
}

class MainApp extends StatelessWidget {
  MainApp({this.themeMode = ThemeMode.system});

  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CCU Toolbox',
      theme: MinimalLightTheme().data,
      darkTheme: MinimalDarkTheme().data,
      themeMode: themeMode ?? ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/ecourse2home':
            return SlidePageTransition(widget: Ecourse2HomeScreen());
            break;
          case '/timetable':
            return SlidePageTransition(widget: TimetableScreen());
            break;
          case '/grade':
            return SlidePageTransition(widget: GradeScreen());
            break;
          case '/transport':
            return SlidePageTransition(widget: TransportScreen());
            break;
          case '/schedule':
            return SlidePageTransition(widget: ScheduleScreen());
            break;
          case '/setting':
            return SlidePageTransition(widget: SettingScreen());
            break;
          case '/about':
            return SlidePageTransition(widget: AboutScreen());
            break;
          case '/attendance':
            return SlidePageTransition(widget: CourseSetAttendanceScreen());
            break;
          case '/login':
            return SlidePageTransition(
                widget: LoginScreen(redirect: settings.arguments));
            break;
          default:
            return null;
        }
      },
    );
  }
}
