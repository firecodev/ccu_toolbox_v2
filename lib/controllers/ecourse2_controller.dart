import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ccu_toolbox/environments/ecourse2_param.dart';
import 'package:ccu_toolbox/helper/shared_preferences_helper.dart';
import 'package:ccu_toolbox/helper/database_helper.dart';
import 'package:ccu_toolbox/models/course.dart';
import 'package:ccu_toolbox/models/ecourse2/announcement.dart';
import 'package:ccu_toolbox/models/ecourse2/assignment.dart';
import 'package:ccu_toolbox/models/ecourse2/score.dart';
import 'package:ccu_toolbox/models/ecourse2/file.dart';

class Ecourse2Controller {
  _Ecourse2Credential _ecourse2Credential = _Ecourse2Credential();

  Future<List<Course>> get getCourses async {
    List<Course> courses = [];
    List<Course> coursesFromJson = [];
    bool useCacheToken = true;
    int retryCount = 0;

    while (true)
      try {
        String token = await _ecourse2Credential.getToken(useCacheToken);
        final response = await _webService(
          token,
          getEcourse2WsFunction('courses'),
          {
            'classification': 'inprogress',
          },
        ) as Map;

        /* Convert to Course object */
        final coursesOrigin = response['courses'] as List;
        coursesOrigin.forEach((course) {
          coursesFromJson.add(Course(
            id: course['idnumber'],
            ecourse2Id: course['id'],
            name: course['fullname'],
          ));
        });

        break;
      } on TokenException catch (err) {
        useCacheToken = false;
        retryCount++;
        if (retryCount > 1) throw err;
      } catch (err) {
        throw err;
      }

    try {
      /* Combine data from DB */
      final dbData = await DatabaseHelper.getData('courses');
      final coursesFromDatabase = dbData.map((e) => Course.fromMap(e)).toList();
      coursesFromJson.forEach((course) {
        Course dbCourse = coursesFromDatabase.firstWhere(
          (element) => element.id == course.id,
          orElse: () => Course(id: course.id),
        );
        courses.add(Course(
          id: course.id,
          ecourse2Id: course.ecourse2Id,
          name: course.name,
          teacher: dbCourse.teacher,
          type: dbCourse.type,
        ));
      });

      /* Sync data to DB */
      // TODO
    } catch (err) {
      throw err;
    }

    return courses;
  }

  Future<List<Announcement>> getAnnouncements(Course course) async {
    List<Announcement> announcements = [];

    try {
      final token = await _ecourse2Credential.getToken(true);
      final response = await _webService(
        token,
        getEcourse2WsFunction('forums'),
        {
          'courseids[0]': course.ecourse2Id.toString(),
        },
      ) as List;

      final newsForumId = response
          .firstWhere((element) => element['type'] == "news")['id'] as int;

      final response2 = await _webService(
        token,
        getEcourse2WsFunction('discussions'),
        {
          'forumid': newsForumId.toString(),
        },
      ) as Map;

      /* Convert to Announcement object */
      final discussionsOrigin = response2['discussions'] as List;
      announcements = discussionsOrigin.map<Announcement>((e) {
        String content = e['message'];
        List<Ecourse2File> files = [];
        if (e.containsKey('messageinlinefiles')) {
          final mlfs = e['messageinlinefiles'] as List;
          mlfs.forEach((element) {
            if (!element['isexternalfile']) {
              content = content.replaceAll(element['fileurl'] as String,
                  (element['fileurl'] as String) + '?token=$token');
            }
          });
        }
        if (e.containsKey('attachments')) {
          final attachs = e['attachments'] as List;
          attachs.forEach((element) {
            if (element['isexternalfile']) {
              files.add(Ecourse2File(
                filename: element['filename'] as String,
                url: element['fileurl'] as String,
                filetype: element['mimetype'] as String,
                size: element['filesize'] as int,
              ));
            } else {
              files.add(Ecourse2File(
                filename: element['filename'] as String,
                url: (element['fileurl'] as String) + '?token=$token',
                filetype: element['mimetype'] as String,
                size: element['filesize'] as int,
              ));
            }
          });
        }
        return Announcement(
          subject: e['subject'],
          creatorname: e['userfullname'],
          createdTime: DateTime.fromMillisecondsSinceEpoch(e['created'] * 1000),
          pinned: e['pinned'],
          content: content,
          files: files,
        );
      }).toList();

      /* Sync data to DB */
      // TODO
    } on TokenException catch (err) {
      await _ecourse2Credential.getToken(false);
      throw err;
    } catch (err) {
      throw err;
    }

    return announcements;
  }

  Future<List<Assignment>> getAssignments(Course course) async {
    List<Assignment> assignments = [];

    try {
      final token = await _ecourse2Credential.getToken(true);
      final response = await _webService(
        token,
        getEcourse2WsFunction('assignment'),
        {
          'courseids[0]': course.ecourse2Id.toString(),
        },
      ) as Map;

      /* Convert to Assignment object */
      final assignmentOrigin =
          ((response['courses'] as List).first as Map)['assignments'] as List;
      assignments = assignmentOrigin.map<Assignment>((e) {
        String intro = e['intro'] ?? '';
        List<Ecourse2File> files = [];
        if (e.containsKey('introfiles')) {
          final ifs = e['introfiles'] as List;
          ifs.forEach((element) {
            if (!element['isexternalfile']) {
              intro = intro.replaceAll(element['fileurl'] as String,
                  (element['fileurl'] as String) + '?token=$token');
            }
          });
        }
        if (e.containsKey('introattachments')) {
          final attachs = e['introattachments'] as List;
          attachs.forEach((element) {
            if (element['isexternalfile']) {
              files.add(Ecourse2File(
                filename: element['filename'] as String,
                url: element['fileurl'] as String,
                filetype: element['mimetype'] as String,
                size: element['filesize'] as int,
              ));
            } else {
              files.add(Ecourse2File(
                filename: element['filename'] as String,
                url: (element['fileurl'] as String) + '?token=$token',
                filetype: element['mimetype'] as String,
                size: element['filesize'] as int,
              ));
            }
          });
        }
        return Assignment(
          id: e['id'],
          name: e['name'],
          startTime: DateTime.fromMillisecondsSinceEpoch(
              e['allowsubmissionsfromdate'] * 1000),
          dueTime: DateTime.fromMillisecondsSinceEpoch(e['duedate'] * 1000),
          cutoffTime:
              DateTime.fromMillisecondsSinceEpoch(e['cutoffdate'] * 1000),
          intro: intro,
          grade: e['grade'],
          files: files,
        );
      }).toList();

      /* Sync data to DB */
      // TODO
    } on TokenException catch (err) {
      await _ecourse2Credential.getToken(false);
      throw err;
    } catch (err) {
      throw err;
    }

    assignments.sort((a, b) => b.dueTime.compareTo(a.dueTime));

    return assignments;
  }

  Future<List<Score>> getScores(Course course) async {
    List<Score> scores = [];

    try {
      final token = await _ecourse2Credential.getToken(true);
      final userid = await _ecourse2Credential.getUserid;
      final response = await _webService(
        token,
        getEcourse2WsFunction('grade'),
        {
          'courseid': course.ecourse2Id.toString(),
          'userid': userid.toString(),
        },
      ) as Map;

      /* Convert to Score object */
      final scoreOrigin =
          ((response['usergrades'] as List).first as Map)['gradeitems'] as List;

      scores = scoreOrigin.map((e) {
        if (e['itemmodule'] == 'attendance')
          return Score(
            name: '出缺席',
            grade: e['gradeformatted'] ?? '-',
            weight: e['weightformatted'] ?? '-',
            rank: (e['rank'] != null && e['rank'] != 0)
                ? e['rank'].toString()
                : '-',
            total: e['numusers']?.toString() ?? '-',
            type: e['itemtype'],
          );
        else
          return Score(
            name: e['itemname'],
            grade: e['gradeformatted'] ?? '-',
            weight: e['weightformatted'] ?? '-',
            rank: (e['rank'] != null && e['rank'] != 0)
                ? e['rank'].toString()
                : '-',
            total: e['numusers']?.toString() ?? '-',
            type: e['itemtype'],
          );
      }).toList();

      /* Sync data to DB */
      // TODO
    } on TokenException catch (err) {
      await _ecourse2Credential.getToken(false);
      throw err;
    } catch (err) {
      throw err;
    }

    return scores;
  }

  Future<List<Ecourse2FileList>> getFileLists(Course course) async {
    List<Ecourse2FileList> fileLists = [];

    try {
      final token = await _ecourse2Credential.getToken(true);
      final response = await _webService(
        token,
        getEcourse2WsFunction('content'),
        {
          'courseid': course.ecourse2Id.toString(),
        },
      ) as List;

      /* Convert to Ecourse2FileList object */
      response.forEach((topic) {
        var modules = topic['modules'] as List;
        Ecourse2FileList tempFileList =
            Ecourse2FileList(title: topic['name'], files: []);
        modules
            .where((module) => module['modname'] == 'resource')
            .forEach((module) {
          var contents = module['contents'] as List;
          contents.forEach((content) {
            if (content['isexternalfile']) {
              tempFileList.files.add(Ecourse2File(
                filename: content['filename'] as String,
                name: module['name'],
                url: content['fileurl'] as String,
                filetype: content['mimetype'] as String,
                size: content['filesize'] as int,
              ));
            } else {
              tempFileList.files.add(Ecourse2File(
                filename: content['filename'] as String,
                name: module['name'],
                url: (content['fileurl'] as String) + '&token=$token',
                filetype: content['mimetype'] as String,
                size: content['filesize'] as int,
              ));
            }
          });
        });
        if (tempFileList.files.isNotEmpty) fileLists.add(tempFileList);
      });

      /* Sync data to DB */
      // TODO
    } on TokenException catch (err) {
      await _ecourse2Credential.getToken(false);
      throw err;
    } catch (err) {
      throw err;
    }

    return fileLists;
  }
}

class _Ecourse2Credential {
  String token = '';
  int userid = -1;

  Future<String> getToken(bool useCache) async {
    if (useCache && token.isNotEmpty) return token;

    SharedPreferences prefs;

    try {
      await SharedPreferencesHelper.versionChecker();
      prefs = await SharedPreferences.getInstance();
    } catch (err) {
      throw err;
    }

    if (useCache) {
      try {
        String tempToken = prefs.getString('moodletoken');

        if (tempToken != null && tempToken.isNotEmpty) token = tempToken;
      } catch (err) {}

      if (token.isNotEmpty) return token;
    }

    String username = '';
    String password = '';

    try {
      username = prefs.getString('username');
      password = prefs.getString('password');
    } catch (err) {
      throw LoginException();
    }

    if (username == null ||
        username.isEmpty ||
        password == null ||
        password.isEmpty) throw LoginException();

    final String appToken = getEcourse2AppToken;

    try {
      final response = await http
          .post(getEcourse2Url('base') + getEcourse2Url('login'), headers: {
        'User-Agent': getUserAgent,
      }, body: {
        'username': username,
        'password': password,
        'apptoken': appToken,
        'service': 'moodle_mobile_app',
      });

      final Map<String, dynamic> decodedResponse = jsonDecode(response.body);

      if (decodedResponse.containsKey('errorcode')) {
        switch (decodedResponse['errorcode']) {
          case 'invalidlogin':
            throw LoginException();
          default:
            throw MoodleException(decodedResponse['errorcode']);
        }
      }

      token = decodedResponse['token'];
    } catch (err) {
      throw err;
    }

    /* Save token to SharedPreferences */
    try {
      prefs.setString('moodletoken', token);
    } catch (err) {}

    return token;
  }

  Future<int> get getUserid async {
    if (userid >= 0) return userid;

    SharedPreferences prefs;

    try {
      await SharedPreferencesHelper.versionChecker();
      prefs = await SharedPreferences.getInstance();
    } catch (err) {
      throw err;
    }

    try {
      int tempUserid = prefs.getInt('moodleuserid');

      if (tempUserid != null && tempUserid >= 0) userid = tempUserid;
    } catch (err) {}

    if (userid >= 0) return userid;

    try {
      if (token.isEmpty) await getToken(true);

      final response = await _webService(
        token,
        getEcourse2WsFunction('siteInfo'),
        {},
      ) as Map;

      userid = response['userid'];
    } on TokenException catch (err) {
      await getToken(false);
      throw err;
    } catch (err) {
      throw err;
    }

    /* Save userid to SharedPreferences */
    try {
      prefs.setInt('moodleuserid', userid);
    } catch (err) {}

    return userid;
  }
}

class LoginException implements Exception {
  String toString() => 'Invalid login.';
}

class TokenException implements Exception {
  String toString() => 'Invalid token.';
}

class MoodleException implements Exception {
  MoodleException(this._errorcode);

  final _errorcode;

  String toString() => '$_errorcode';
}

Future<dynamic> _webService(
    String token, String function, Map<String, String> params) async {
  Map<String, String> body = {
    'moodlewssettingfilter': '1',
    'moodlewssettingfileurl': '1',
    'moodlewsrestformat': 'json',
    'wstoken': token,
    'wsfunction': function,
  };

  body.addAll(params);

  try {
    final response = await http.post(
      getEcourse2Url('base') + getEcourse2Url('webservice'),
      headers: {
        'User-Agent': getUserAgent,
      },
      body: body,
    );

    final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

    if (decodedResponse is Map && decodedResponse.containsKey('errorcode')) {
      switch (decodedResponse['errorcode']) {
        case 'invalidtoken':
          throw TokenException();
        default:
          throw MoodleException(decodedResponse['errorcode']);
      }
    }

    return decodedResponse;
  } catch (err) {
    throw err;
  }
}

Future<void> verifyLogin(String username, String password) async {
  if (username == null ||
      username.isEmpty ||
      password == null ||
      password.isEmpty) throw LoginException();

  final String appToken = getEcourse2AppToken;

  try {
    final response = await http
        .post(getEcourse2Url('base') + getEcourse2Url('login'), headers: {
      'User-Agent': getUserAgent,
    }, body: {
      'username': username,
      'password': password,
      'apptoken': appToken,
      'service': 'moodle_mobile_app',
    });

    final Map<String, dynamic> decodedResponse = jsonDecode(response.body);

    if (decodedResponse.containsKey('errorcode')) {
      switch (decodedResponse['errorcode']) {
        case 'invalidlogin':
          throw LoginException();
        default:
          throw MoodleException(decodedResponse['errorcode']);
      }
    }
  } catch (err) {
    throw err;
  }
}
