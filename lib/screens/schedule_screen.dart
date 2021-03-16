import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ccu_toolbox/models/schedule/schedule.dart';
import 'package:ccu_toolbox/widgets/minimal_scaffold.dart';

class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MinimalScaffold(
      title: '行事曆',
      body: FutureBuilder<List<ScheduleDay>>(
        future: getSchedule(),
        builder: (ctx, snapshot) {
          if (snapshot.hasError) {
            return SizedBox();
          }
          if (snapshot.hasData) {
            final now = DateTime.now();
            int initIndex = snapshot.data.length - 1;
            for (int i = 0; i < snapshot.data.length; i++) {
              if (snapshot.data[i].date.isAfter(now)) {
                initIndex = i - 1;
                break;
              }
            }
            if (initIndex < 0) {
              initIndex = 0;
            }
            return ScrollablePositionedList.builder(
              itemCount: snapshot.data.length,
              initialScrollIndex: initIndex,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: DayCard(
                    scheduleDay: snapshot.data[index],
                    now: now,
                  ),
                );
              },
            );
          } else {
            return Center(
              child: SpinKitThreeBounce(
                size: 20.0,
                color: Colors.blue,
                duration: Duration(milliseconds: 1200),
              ),
            );
          }
        },
      ),
    );
  }
}

class DayCard extends StatelessWidget {
  DayCard({@required this.scheduleDay, this.now});

  final ScheduleDay scheduleDay;
  final DateTime now;

  static const List<String> weekday = ['', '一', '二', '三', '四', '五', '六', '日'];

  @override
  Widget build(BuildContext context) {
    bool sameDay = (scheduleDay.date.year == now.year) &&
        (scheduleDay.date.month == now.month) &&
        (scheduleDay.date.day == now.day);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: Text(
            DateFormat('MM/dd').format(scheduleDay.date) +
                ' (' +
                weekday[scheduleDay.date.weekday] +
                ')',
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: sameDay ? FontWeight.bold : null,
                color: Color(0xFF9E9E9E)),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: scheduleDay.events
              .map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: Text(
                      e.content,
                      style: TextStyle(
                          color: e.holiday ? Colors.red : null, fontSize: 14.0),
                    ),
                  ))
              .toList(),
        ),
        SizedBox(height: 15.0),
      ],
    );
  }
}

Future<List<ScheduleDay>> getSchedule() async {
  List<ScheduleDay> result = [];

  final dataString = await rootBundle.loadString('lib/assets/schedule.csv');
  result = await compute(parse, dataString);

  return result;
}

List<ScheduleDay> parse(String dataString) {
  List<ScheduleDay> result = [];

  final res = const CsvToListConverter()
      .convert(dataString, eol: '\n', shouldParseNumbers: false);

  String lastDate = '';
  List<ScheduleEvent> tempEvents = [];
  res.forEach((element) {
    if (element[0] != lastDate) {
      if (lastDate.isNotEmpty) {
        result.add(ScheduleDay(
          date: DateTime.parse(lastDate),
          events: tempEvents,
        ));
      }
      tempEvents = [];

      lastDate = element[0];
      tempEvents.add(ScheduleEvent(
        holiday: element[1] == 'Y',
        content: element[2],
      ));
    } else {
      tempEvents.add(ScheduleEvent(
        holiday: element[1] == 'Y',
        content: element[2],
      ));
    }
  });

  return result;
}
