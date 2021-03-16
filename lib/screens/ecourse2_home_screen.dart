import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ccu_toolbox/controllers/ecourse2_controller.dart';
import 'package:ccu_toolbox/models/course.dart';
import 'package:ccu_toolbox/screens/course_screen.dart';
import 'package:ccu_toolbox/widgets/minimal_scaffold.dart';
import 'package:ccu_toolbox/widgets/bounce_button.dart';
import 'package:ccu_toolbox/widgets/error_indicator.dart';
import 'package:ccu_toolbox/widgets/slide_page_transition.dart';

class Ecourse2HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => Ecourse2Controller(),
      child: _BuildScreen(),
    );
  }
}

class _BuildScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MinimalScaffold(
      title: 'eCourse2',
      body: SafeArea(
        child: FutureBuilder<List<Course>>(
          future: context.read<Ecourse2Controller>().getCourses,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              switch (snapshot.error.runtimeType) {
                case SocketException:
                  return Center(child: NetworkErrorIndicator());
                  break;
                case LoginException:
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacementNamed(context, '/login',
                        arguments: '/ecourse2home');
                  });
                  return Center(child: LoginErrorIndicator());
                  break;
                case TokenException:
                  return Center(child: TryAgainIndicator());
                  break;
                default:
                  return Center(child: UnknownErrorIndicator());
              }
            } else if (snapshot.hasData) {
              if (snapshot.data.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_cafe_rounded,
                        color: Theme.of(context).textTheme.subtitle1.color,
                        size: 45.0,
                      ),
                      Text(
                        '目前沒有課程',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.subtitle1.color,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return ListView.separated(
                  itemBuilder: (_, index) {
                    return _CourseCard(course: snapshot.data[index]);
                  },
                  separatorBuilder: (_, __) => Divider(
                    thickness: 1.0,
                    height: 1.0,
                    indent: 73.0,
                    endIndent: 30.0,
                  ),
                  itemCount: snapshot.data.length,
                );
              }
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
      ),
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
    return BounceButton(
      onTap: () {
        Navigator.push(
          context,
          SlidePageTransition(
            widget: Provider.value(
              value: context.read<Ecourse2Controller>(),
              child: CourseScreen(course: course),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 30.0),
        child: SizedBox(
          height: 65.0,
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
                      course.teacher,
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
    );
  }
}
