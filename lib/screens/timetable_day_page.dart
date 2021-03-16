import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ccu_toolbox/models/course.dart';
import 'package:ccu_toolbox/widgets/minimal_tab_bar.dart';
import 'package:ccu_toolbox/widgets/bounce_button.dart';

class TimetableDayPage extends StatefulWidget {
  TimetableDayPage(
      {Key key, @required this.coursesList, this.isLoading = false});

  final List<List<Course>> coursesList;
  final bool isLoading;

  @override
  _TimetableDayPageState createState() => _TimetableDayPageState();
}

class _TimetableDayPageState extends State<TimetableDayPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  static final List<String> items = <String>['一', '二', '三', '四', '五'];

  static final List<Tab> tabs = items
      .map<Tab>((item) => Tab(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9.0),
              child: Text(
                item,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ))
      .toList(growable: false);

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: tabs.length,
      initialIndex: DateTime.now().weekday > 5 ? 0 : DateTime.now().weekday - 1,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        MinimalTabBar(
          tabController: _tabController,
          tabs: tabs,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 9.0),
            child: widget.isLoading
                ? Center(
                    child: SpinKitThreeBounce(
                      size: 20.0,
                      color: Colors.blue,
                      duration: Duration(milliseconds: 1200),
                    ),
                  )
                : TabBarView(
                    controller: _tabController,
                    children: [
                      WeekdayList(courses: widget.coursesList[1]),
                      WeekdayList(courses: widget.coursesList[2]),
                      WeekdayList(courses: widget.coursesList[3]),
                      WeekdayList(courses: widget.coursesList[4]),
                      WeekdayList(courses: widget.coursesList[5]),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

class WeekdayList extends StatelessWidget {
  WeekdayList({Key key, @required this.courses});

  final List<Course> courses;

  @override
  Widget build(BuildContext context) {
    return courses.isEmpty
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.local_cafe_rounded,
                  color: Theme.of(context).textTheme.subtitle1.color,
                  size: 45.0,
                ),
                Text(
                  '當天沒有課程',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.subtitle1.color,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            itemBuilder: (_, index) {
              return _CourseCard(course: courses[index]);
            },
            itemCount: courses.length,
          );
  }
}

class _CourseCard extends StatelessWidget {
  _CourseCard({@required this.course});

  final Course course;

  static const Map<String, Color> colors = {
    '必修': Color(0xFF00AF12),
    '選修': Color(0xFF0072C5),
    '通識': Color(0xFFFFC700),
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 23.0),
      child: BounceButton(
        child: Container(
          height: 73.0,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border:
                Border.all(color: Theme.of(context).textTheme.subtitle1.color),
            borderRadius: BorderRadius.circular(7.0),
            boxShadow: [
              BoxShadow(
                  offset: Offset.fromDirection(1.5, 2),
                  blurRadius: 1.0,
                  color: Color.fromRGBO(0, 0, 0, 0.10))
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 14.0),
                  child: Container(
                    height: 39.0,
                    width: 39.0,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: colors[course.type] ?? Color(0xFF5F5F5F),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        course.type,
                        style: TextStyle(color: Colors.white, fontSize: 13.0),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.name,
                        style: TextStyle(fontSize: 17.0),
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        '${_minuteToString(course.time.first.starttime)} - ${_minuteToString(course.time.first.endtime)} / ${course.classroom}',
                        style:
                            TextStyle(color: Color(0xFF9E9E9E), fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
