class BusStop {
  String name;
  String time;
  String car;
  bool accessible;

  BusStop({
    this.name = '未知',
    this.time = '',
    this.car = '',
    this.accessible = false,
  });

  String toString() => '$name';
}
