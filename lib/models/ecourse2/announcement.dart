import 'file.dart';

class Announcement {
  String subject;
  String creatorname;
  DateTime createdTime;
  bool pinned;
  String content;
  List<Ecourse2File> files;

  Announcement({
    this.subject,
    this.creatorname,
    this.createdTime,
    this.pinned,
    this.content,
    this.files,
  });

  String toString() => '$subject';
}
