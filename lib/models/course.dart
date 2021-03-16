import 'package:flutter/foundation.dart';

class Course {
  String id; // 109_1_4102001_02
  int ecourse2Id;
  String name;
  String teacher;
  String type;
  String credit;
  String classroom;
  String timeString; // For saving to database
  List<CourseTime> time;
  String grade; // For final grade, not for eCourse2

  Course({
    @required this.id,
    this.ecourse2Id = -1,
    this.name = '未知',
    this.teacher = '未知',
    this.type = '未知',
    this.credit = '未知',
    this.classroom = '未知',
    this.timeString = '',
    this.time = const [],
    this.grade = '未知',
  });

  Course.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        ecourse2Id = map['ecourse2Id'],
        name = map['name'],
        teacher = map['teacher'],
        type = map['type'],
        credit = map['credit'],
        classroom = map['classroom'],
        timeString = map['timeString'];

  String toString() => '$id $name';

  Map<String, dynamic> toMap() => {
        'id': id,
        'ecourse2Id': ecourse2Id,
        'name': name,
        'teacher': teacher,
        'type': type,
        'credit': credit,
        'classroom': classroom,
        'timeString': timeString,
      };
}

class CourseTime {
  CourseTime({
    this.weekday = -1,
    this.starttime = 0,
    this.endtime = 0,
  });

  int weekday;
  int starttime;
  int endtime;
}
