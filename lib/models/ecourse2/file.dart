class Ecourse2File {
  String filename;
  String name;
  String url;
  String filetype;
  int size;

  Ecourse2File({this.filename, this.name, this.url, this.filetype, this.size});
}

class Ecourse2FileList {
  String title;
  List<Ecourse2File> files;

  Ecourse2FileList({this.title, this.files});
}
