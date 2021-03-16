import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ccu_toolbox/controllers/ecourse2_controller.dart';
import 'package:ccu_toolbox/models/course.dart';
import 'package:ccu_toolbox/models/ecourse2/score.dart';
import 'package:ccu_toolbox/widgets/error_indicator.dart';

class CourseScorePage extends StatefulWidget {
  @override
  _CourseScorePageState createState() => _CourseScorePageState();
}

class _CourseScorePageState extends State<CourseScorePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SafeArea(
      child: FutureBuilder<List<Score>>(
        future: context
            .read<Ecourse2Controller>()
            .getScores(context.read<Course>()),
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
                      '目前沒有成績',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.subtitle1.color,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: DataTable(
                    horizontalMargin: 0.0,
                    columnSpacing: 8.0,
                    headingRowHeight: 50.0,
                    dataRowHeight: 40.0,
                    headingTextStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFF9E9E9E)),
                    columns: <DataColumn>[
                      DataColumn(label: Text('項目')),
                      DataColumn(label: Text('佔比')),
                      DataColumn(label: Text('成績')),
                      DataColumn(label: Text('排名')),
                    ],
                    rows: snapshot.data.map((e) {
                      switch (e.type) {
                        case 'category':
                          return DataRow(
                            cells: <DataCell>[
                              DataCell(SizedBox(
                                width: 150.0,
                                child: Text('子類別',
                                    style: TextStyle(
                                        color: Color(0xFF9E9E9E),
                                        fontStyle: FontStyle.italic)),
                              )),
                              DataCell(Text(e.weight,
                                  style: TextStyle(
                                      color: Color(0xFF9E9E9E),
                                      fontStyle: FontStyle.italic))),
                              DataCell(Text(e.grade,
                                  style: TextStyle(
                                      color: Color(0xFF9E9E9E),
                                      fontStyle: FontStyle.italic))),
                              DataCell(Text('${e.rank}/${e.total}',
                                  style: TextStyle(
                                      color: Color(0xFF9E9E9E),
                                      fontStyle: FontStyle.italic))),
                            ],
                          );
                          break;
                        case 'course':
                          return DataRow(
                            cells: <DataCell>[
                              DataCell(SizedBox(
                                width: 150.0,
                                child: Text('課程總分',
                                    style: TextStyle(color: Color(0xFF9E9E9E))),
                              )),
                              DataCell(Text(e.weight,
                                  style: TextStyle(color: Color(0xFF9E9E9E)))),
                              DataCell(Text(e.grade,
                                  style: TextStyle(color: Color(0xFF9E9E9E)))),
                              DataCell(Text('${e.rank}/${e.total}',
                                  style: TextStyle(color: Color(0xFF9E9E9E)))),
                            ],
                          );
                          break;
                        default:
                          return DataRow(
                            cells: <DataCell>[
                              DataCell(SizedBox(
                                width: 150.0,
                                child: Text(e.name),
                              )),
                              DataCell(Text(e.weight)),
                              DataCell(Text(e.grade)),
                              DataCell(Text('${e.rank}/${e.total}')),
                            ],
                          );
                      }
                    }).toList(),
                  ),
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
