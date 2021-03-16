class Train {
  String no;
  String name;
  String type;
  String to;
  DateTime arrivalTime;
  int delay; // less than 0 means no data

  Train({
    this.no = '？',
    this.name = '未知',
    this.type = '',
    this.to = '未知',
    this.arrivalTime,
    this.delay = -1,
  });

  String toString() => '$no $name';
}
