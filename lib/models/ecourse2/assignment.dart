import 'file.dart';

class Assignment {
  int id;
  String name;
  DateTime startTime;
  DateTime dueTime;
  DateTime cutoffTime;
  String intro;
  int grade;
  List<Ecourse2File> files;

  Assignment({
    this.id,
    this.name,
    this.startTime,
    this.dueTime,
    this.cutoffTime,
    this.intro,
    this.grade,
    this.files,
  });

  String toString() => '$name';
}
