import 'package:flutter/material.dart';
import 'package:ccu_toolbox/models/course.dart';

class TimetableWeekPage extends StatelessWidget {
  TimetableWeekPage({Key key, @required this.coursesList});

  final List<List<Course>> coursesList;
  final List<String> weekday = ['一', '二', '三', '四', '五'];
  final DateTime nowTime = DateTime.now();
  final List<Color> colorList = [
    Color(0xFFFFEBEB),
    Color(0xFFFFE9D4),
    Color(0xFFFFFFCC),
    Color(0xFFE7FFCF),
    Color(0xFFDEFFDE),
    Color(0xFFD1FFE8),
    Color(0xFFCCFFFF),
    Color(0xFFE0F0FF),
    Color(0xFFE6E6FF),
    Color(0xFFF1E3FF),
    Color(0xFFFFE6FF),
    Color(0xFFFFE3F1),
  ];

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        child: SizedBox(
          height: 495.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 30.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    16,
                    (index) => Container(
                      height: 30.0,
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                              color:
                                  Theme.of(context).textTheme.subtitle1.color,
                              width: 1.0),
                        ),
                        color: index.isEven
                            ? Theme.of(context).scaffoldBackgroundColor
                            : Theme.of(context).textTheme.subtitle1.color,
                      ),
                      child: index == 0
                          ? null
                          : Center(
                              child: Text('$index'),
                            ),
                    ),
                  ),
                ),
              ),
              ...List.generate(
                5,
                (index) => Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 30.0,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color:
                                  Theme.of(context).textTheme.subtitle1.color,
                              width: 1.0,
                            ),
                            bottom: BorderSide(
                              color:
                                  Theme.of(context).textTheme.subtitle1.color,
                              width: 1.0,
                            ),
                          ),
                          color: index.isOdd
                              ? Theme.of(context).textTheme.subtitle1.color
                              : Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: Center(
                          child: Text('星期${weekday[index]}'),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: LayoutBuilder(builder: (ctx, constraints) {
                          return Stack(
                            children: [
                              ...coursesList[index + 1].map((course) {
                                return Positioned(
                                  top: (course.time.first.starttime - 420) / 2,
                                  width: constraints.maxWidth,
                                  child: Material(
                                    color: colorList[course.name.hashCode %
                                        colorList.length],
                                    child: InkWell(
                                      onTap: () {},
                                      child: Container(
                                        height: (course.time.first.endtime -
                                                course.time.first.starttime) /
                                            2,
                                        child: Stack(
                                          children: <Widget>[
                                            Positioned(
                                              top: 0,
                                              left: 0,
                                              child: Text(
                                                '${_minuteToString(course.time.first.starttime)}',
                                                style: TextStyle(
                                                    fontSize: 5.0,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: Text(
                                                '${_minuteToString(course.time.first.endtime)}',
                                                style: TextStyle(
                                                    fontSize: 5.0,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: Center(
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    '${course.name}',
                                                    style: TextStyle(
                                                        fontSize: 10.0,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              if (index == nowTime.weekday - 1 &&
                                  (nowTime.hour > 6 && nowTime.hour < 22))
                                Positioned(
                                  top: ((nowTime.hour * 60 + nowTime.minute) -
                                              420) /
                                          2 -
                                      1,
                                  width: constraints.maxWidth,
                                  child: Container(
                                    height: 2.0,
                                    child: Material(
                                      elevation: 3.0,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _minuteToString(int minute) {
  int hour = minute ~/ 60;
  int remainMin = minute % 60;

  return hour.toString().padLeft(2, '0') +
      ':' +
      remainMin.toString().padLeft(2, '0');
}
