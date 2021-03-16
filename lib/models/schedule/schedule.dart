class ScheduleDay {
  DateTime date;
  List<ScheduleEvent> events;

  ScheduleDay({
    this.date,
    this.events = const [],
  }) : assert(date != null);

  String toString() => '$date';
}

class ScheduleEvent {
  bool holiday;
  String content;

  ScheduleEvent({
    this.holiday = false,
    this.content = '',
  });
}
