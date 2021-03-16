import 'dart:math';

part 'ecourse2_app_token.dart';

String get getUserAgent => 'CCUToolbox/2';

const Map<String, String> _urls = {
  'base':
      'https://ecourse2.ccu.edu.tw/', // Be aware, this url should end with '/'
  'login': 'login/token.php',
  'webservice': 'webservice/rest/server.php',
};

String getEcourse2Url(String index) => _urls[index];

const Map<String, String> _wsfunctions = {
  'siteInfo': 'core_webservice_get_site_info',
  'courses': 'core_course_get_enrolled_courses_by_timeline_classification',
  'forums': 'mod_forum_get_forums_by_courses',
  'discussions': 'mod_forum_get_forum_discussions',
  'assignment': 'mod_assign_get_assignments',
  'grade': 'gradereport_user_get_grade_items',
  'content': 'core_course_get_contents',
};

String getEcourse2WsFunction(String index) => _wsfunctions[index];
