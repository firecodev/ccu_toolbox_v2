import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ccu_toolbox/controllers/ecourse2_controller.dart';
import 'package:ccu_toolbox/models/course.dart';
import 'package:ccu_toolbox/models/ecourse2/assignment.dart';
import 'package:ccu_toolbox/widgets/bounce_button.dart';
import 'package:ccu_toolbox/widgets/error_indicator.dart';
import 'package:ccu_toolbox/widgets/slide_page_transition.dart';
import 'course_assignment_screen.dart';

class CourseAssignmentPage extends StatefulWidget {
  @override
  _CourseAssignmentPageState createState() => _CourseAssignmentPageState();
}

class _CourseAssignmentPageState extends State<CourseAssignmentPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SafeArea(
      child: FutureBuilder<List<Assignment>>(
        future: context
            .read<Ecourse2Controller>()
            .getAssignments(context.read<Course>()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            switch (snapshot.error.runtimeType) {
              case SocketException:
                return Center(child: NetworkErrorIndicator());
                break;
              case LoginException:
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
                      '目前沒有作業',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.subtitle1.color,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return ShaderMask(
                shaderCallback: (Rect rect) {
                  return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.purple,
                        Colors.transparent,
                      ],
                      stops: [
                        0.0,
                        0.03,
                      ]).createShader(rect);
                },
                blendMode: BlendMode.dstOut,
                child: ListView.separated(
                  itemBuilder: (_, index) {
                    return _AssignmentCard(assignment: snapshot.data[index]);
                  },
                  separatorBuilder: (_, __) => Divider(
                    thickness: 1.0,
                    height: 1.0,
                    indent: 25.0,
                    endIndent: 25.0,
                  ),
                  itemCount: snapshot.data.length,
                ),
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
    );
  }
}

class _AssignmentCard extends StatelessWidget {
  _AssignmentCard({@required this.assignment});

  final Assignment assignment;

  @override
  Widget build(BuildContext context) {
    return BounceButton(
      onTap: () {
        Navigator.push(
          context,
          SlidePageTransition(
            widget: Provider.value(
              value: context.read<Ecourse2Controller>(),
              child: CourseAssignmentScreen(assignment: assignment),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: SizedBox(
          height: 71.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assignment.name,
                      style: TextStyle(fontSize: 18.0),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                    SizedBox(height: 3.0),
                    Text(
                      DateFormat('yyyy/MM/dd HH:mm').format(assignment.dueTime),
                      style:
                          TextStyle(color: Color(0xFF9E9E9E), fontSize: 13.0),
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
