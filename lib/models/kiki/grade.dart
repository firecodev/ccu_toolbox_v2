import '../course.dart';

class KikiGrade {
  String title;
  String footer;
  List<Course> courses;

  KikiGrade({
    this.title = '未知學年學期',
    this.footer = '',
    this.courses = const [],
  });
}
