import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html show parse;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ccu_toolbox/environments/kiki_param.dart';
import 'package:ccu_toolbox/helper/shared_preferences_helper.dart';
import 'package:ccu_toolbox/helper/database_helper.dart';
import 'package:ccu_toolbox/models/course.dart';
import 'package:ccu_toolbox/models/kiki/grade.dart';

class KikiController {
  _KikiCredential _kikiCredential = _KikiCredential();

  Stream<List<Course>> get getCourses async* {
    List<Course> courses = [];
    bool hasData = false;

    try {
      final dbData = await DatabaseHelper.getData('courses');
      final coursesFromDatabase = dbData.map((e) => Course.fromMap(e)).toList();
      if (coursesFromDatabase.isNotEmpty) {
        // yield data from database
        yield await compute(parseTimeFromTimeString, coursesFromDatabase);
        hasData = true;
      }

      final sessionId = await _kikiCredential.getSessionId(true);
      final year = (DateTime.now().month < 8)
          ? (DateTime.now().year - 1912).toString()
          : (DateTime.now().year - 1911).toString();
      final term =
          (DateTime.now().month > 1 && DateTime.now().month < 8) ? '2' : '1';
      final response = await http.get(
        getKikiUrl('base') +
            getKikiUrl('getCourses') +
            '?year=$year&term=$term&session_id=$sessionId',
        headers: {
          'User-Agent': getUserAgent,
        },
      );

      Map<String, String> param = {
        'response': utf8.decode(response.bodyBytes),
        'year': year,
        'term': term,
      };
      List<Course> coursesFromElement = await compute(parseCourseHtml, param);

      /* Combine data from DB */
      coursesFromElement.forEach((course) {
        courses.add(Course(
          id: course.id,
          name: course.name,
          teacher: course.teacher,
          type: course.type,
          credit: course.credit,
          classroom: course.classroom,
          timeString: course.timeString,
          time: course.time,
        ));
      });

      // yield data from internet
      yield courses;

      /* Sync data to DB */
      await DatabaseHelper.deleteAllData('courses');
      await Future.forEach<Course>(courses,
          (course) => DatabaseHelper.insert('courses', course.toMap()));
    } on LoginException catch (err) {
      throw err;
    } catch (err) {
      if (!hasData) throw err;
    }
    return;
  }

  Stream<List<List<Course>>> get getCoursesByWeekday async* {
    var streamWithoutErrors = getCourses.handleError((err) {
      throw err;
    });
    await for (var courses in streamWithoutErrors) {
      yield await compute(coursesByWeekday, courses);
    }

    return;
  }

  Future<List<KikiGrade>> get getGrades async {
    String username = '';
    String password = '';
    List<KikiGrade> result;

    try {
      await SharedPreferencesHelper.versionChecker();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      username = prefs.getString('username');
      password = prefs.getString('password');
    } catch (err) {
      throw LoginException();
    }

    if (username == null ||
        username.isEmpty ||
        password == null ||
        password.isEmpty) throw LoginException();

    try {
      final response = await http.post(
        getKikiUrl('base') + getKikiUrl('grade'),
        headers: {
          'User-Agent': getUserAgent,
        },
        body: {
          'id': username,
          'password': password,
        },
      );

      Map<String, String> param = {
        'response': utf8.decode(response.bodyBytes),
      };
      result = await compute(parseGradeHtml, param);
    } catch (err) {
      throw err;
    }

    return result;
  }
}

class _KikiCredential {
  String sessionId = '';

  Future<String> getSessionId(bool useCache) async {
    if (useCache && sessionId.isNotEmpty) return sessionId;

    String username = '';
    String password = '';

    try {
      await SharedPreferencesHelper.versionChecker();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      username = prefs.getString('username');
      password = prefs.getString('password');
    } catch (err) {
      throw LoginException();
    }

    if (username == null ||
        username.isEmpty ||
        password == null ||
        password.isEmpty) throw LoginException();

    try {
      final response = await http.post(
        getKikiUrl('base') + getKikiUrl('login'),
        headers: {
          'User-Agent': getUserAgent,
        },
        body: {
          'id': username,
          'password': password,
        },
      );

      if (int.parse(response.headers['content-length']) < 1000)
        throw LoginException();

      sessionId =
          Uri.parse(response.headers['location']).queryParameters['session_id'];
    } catch (err) {
      throw err;
    }

    return sessionId;
  }
}

class LoginException implements Exception {
  String toString() => 'Invalid login.';
}

class SessionIdException implements Exception {
  String toString() => 'Invalid session id.';
}

List<Course> parseCourseHtml(Map<String, String> param) {
  final response = param['response'];
  final year = param['year'];
  final term = param['term'];

  final document = html.parse(response);

  /* Build title and index mapping */
  final tableTitles = document.body
      .getElementsByTagName('table')[1]
      .children
      .first // <tbody>
      .children
      .first // <tr>
      .children;

  Map<String, int> titleMap = {};

  tableTitles.asMap().forEach((key, value) {
    titleMap[value.text] = key;
  });
  // Example: {????????????: 0, ????????????: 1, ??????: 2, ????????????: 3, ????????????: 4, ??????: 5, ????????????: 6, ????????????: 7, ??????: 8, ??????: 9}

  /* Convert to Course object */
  List<Course> coursesFromElement = [];
  final courseElements = document.body
      .getElementsByTagName('table')[1]
      .children
      .first // tbody
      .children; // list of <tr>

  courseElements.forEach((element) {
    coursesFromElement.add(Course(
      id: '${year}_${term}_' +
          element.children[titleMap['????????????']].text +
          '_' +
          element.children[titleMap['??????']].text,
      name: element.children[titleMap['????????????']].text,
      teacher: element.children[titleMap['????????????']].text,
      type: element.children[titleMap['????????????']].text,
      credit: element.children[titleMap['??????']].text,
      classroom: element.children[titleMap['??????']].text,
      timeString: element.children[titleMap['????????????']].text,
      time: combineCourseTime(
          parseCourseTime(element.children[titleMap['????????????']].text)),
    ));
  });
  coursesFromElement.removeAt(0);

  return coursesFromElement;
}

List<CourseTime> parseCourseTime(String string) {
  List<CourseTime> courseTimes = [];

  final pureString = string.trim(); // '???10,11 ???C,D ???6,E,9'

  final divideDaysRegex =
      RegExp(r'[^a-zA-Z\d\s,]([A-J]|\d|,)+', multiLine: true, unicode: true);
  final divideChineseRegex =
      RegExp(r'[^a-zA-Z\d,]', multiLine: true, unicode: true);
  final divideTimeRegex = RegExp(r'[A-J\d]+', multiLine: true, unicode: true);

  final resultByDay =
      divideDaysRegex.allMatches(pureString); // ['???10,11', '???C,D', '???6,E,9']

  resultByDay.forEach((day) {
    String dayTime = day.group(0); // '???10,11'

    String chineseDay = divideChineseRegex.firstMatch(dayTime).group(0); // '???'
    int weekday = getWeekday(chineseDay);
    final resultByTime = divideTimeRegex.allMatches(dayTime); // ['10', '11']

    resultByTime.forEach((time) {
      int startTime = getStartTime(time.group(0));
      int endTime = getEndTime(time.group(0));

      if (!(weekday == null || startTime == null || endTime == null)) {
        courseTimes.add(CourseTime(
          weekday: weekday,
          starttime: startTime,
          endtime: endTime,
        ));
      }
    });
  });

  return courseTimes;
}

List<CourseTime> combineCourseTime(List<CourseTime> courseTimes) {
  List<CourseTime> result = [];
  for (int i = 1; i < 8; i++) {
    // Process weekday 1 to 7 respectively
    List<CourseTime> tempList =
        courseTimes.where((courseTime) => courseTime.weekday == i).toList();
    tempList.sort((a, b) => a.starttime.compareTo(b.starttime));

    int lastEndTime = -30;

    tempList.forEach((courseTime) {
      if (courseTime.starttime - lastEndTime > 15) {
        result.add(courseTime);
      } else {
        CourseTime temp = result.removeLast();
        result.add(CourseTime(
          weekday: temp.weekday,
          starttime: temp.starttime,
          endtime: courseTime.endtime,
        ));
      }
      lastEndTime = courseTime.endtime;
    });
  }

  return result;
}

List<List<Course>> coursesByWeekday(List<Course> courses) {
  List<List<Course>> result = [[], [], [], [], [], [], [], []];
  // index 0 is unused, which means start from 1 to 7 (represent Monday to Sunday)
  List<List<Course>> temp = [[], [], [], [], [], [], [], []];

  courses.forEach((course) {
    course.time.forEach((courseTime) {
      temp[courseTime.weekday].add(Course(
        id: course.id,
        ecourse2Id: course.ecourse2Id,
        name: course.name,
        teacher: course.teacher,
        type: course.type,
        credit: course.credit,
        classroom: course.classroom,
        timeString: course.timeString,
        time: [courseTime],
      ));
    });
  });

  for (int i = 1; i < 8; i++) {
    // Process each day courses
    temp[i].sort(
        (a, b) => a.time.first.starttime.compareTo(b.time.first.starttime));
    result[i] = temp[i];
  }

  return result;
}

List<Course> parseTimeFromTimeString(List<Course> courses) {
  final result = courses
      .map((course) => Course(
            id: course.id,
            ecourse2Id: course.ecourse2Id,
            name: course.name,
            teacher: course.teacher,
            type: course.type,
            credit: course.credit,
            classroom: course.classroom,
            timeString: course.timeString,
            time: combineCourseTime(parseCourseTime(course.timeString)),
          ))
      .toList();

  return result;
}

List<KikiGrade> parseGradeHtml(Map<String, String> param) {
  final response = param['response'];

  final rawHtmlList = response.split('</HTML>')[1].split('<P>&nbsp;<P>');

  /* Convert to Course object */
  List<KikiGrade> gradeCollection = [];
  rawHtmlList.forEach((htmlString) {
    if (htmlString.isNotEmpty) {
      var document = html.parse(htmlString);
      String title = document.body.getElementsByTagName('h3').first.text.trim();
      String footer =
          htmlString.split('</TABLE>')[1].replaceFirst('??????????????????', '').trim();
      List<Course> courseList = document.body
          .getElementsByTagName('table')
          .first
          .children
          .first
          .children
          .map((e) => Course(
                id: '0',
                name: e.children[2].text,
                type: e.children[3].text,
                credit: e.children[4].text,
                grade: e.children[5].text == '????????????' ? '??????' : e.children[5].text,
              ))
          .toList();
      courseList.removeAt(0);
      gradeCollection.add(KikiGrade(
        title: title,
        footer: footer,
        courses: courseList,
      ));
    }
  });

  return gradeCollection;
}
