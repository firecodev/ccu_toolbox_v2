import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ccu_toolbox/controllers/kiki_controller.dart';
import 'package:ccu_toolbox/models/kiki/grade.dart';
import 'package:ccu_toolbox/widgets/minimal_scaffold.dart';
import 'package:ccu_toolbox/widgets/error_indicator.dart';
import 'package:ccu_toolbox/widgets/choose_menu_button.dart';

class GradeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => KikiController(),
      child: _BuildScreen(),
    );
  }
}

class _BuildScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MinimalScaffold(
      title: '成績查詢',
      body: FutureBuilder<List<KikiGrade>>(
        future: context.read<KikiController>().getGrades,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            switch (snapshot.error.runtimeType) {
              case SocketException:
                return Center(child: NetworkErrorIndicator());
                break;
              case LoginException:
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacementNamed(context, '/login',
                      arguments: '/grade');
                });
                return Center(child: LoginErrorIndicator());
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
                      '目前沒有資料',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.subtitle1.color,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return GradePage(gradeList: snapshot.data);
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

class GradePage extends StatefulWidget {
  GradePage({Key key, @required this.gradeList});

  final List<KikiGrade> gradeList;

  @override
  _GradePageState createState() => _GradePageState();
}

class _GradePageState extends State<GradePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: DataTable(
                      horizontalMargin: 0.0,
                      columnSpacing: 15.0,
                      headingRowHeight: 40.0,
                      dataRowHeight: 30.0,
                      headingTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9E9E9E)),
                      columns: <DataColumn>[
                        DataColumn(label: Text('項目')),
                        DataColumn(label: Text('屬性')),
                        DataColumn(label: Text('學分')),
                        DataColumn(label: Text('成績')),
                      ],
                      rows: widget.gradeList[index].courses.map((e) {
                        return DataRow(
                          cells: <DataCell>[
                            DataCell(
                              SizedBox(
                                width: 180.0,
                                child: FittedBox(
                                  alignment: Alignment.centerLeft,
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    e.name,
                                    softWrap: false,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(Text(e.type)),
                            DataCell(Text(e.credit)),
                            DataCell(FormattedGrade(e.grade)),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  Divider(
                    thickness: 1.0,
                    height: 1.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                    ),
                    child: Text(
                      widget.gradeList[index].footer,
                      style: TextStyle(color: Color(0xFF9E9E9E)),
                    ),
                  ),
                  SizedBox(height: 70.0),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: ChooseMenuButton(
                buttonText: widget.gradeList[index].title,
                menuTitle: '學期',
                width: 200.0,
                items: widget.gradeList
                    .map((kikiGrade) => SizedBox(
                          height: 50.0,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              kikiGrade.title,
                              style: TextStyle(fontSize: 15.0),
                            ),
                          ),
                        ))
                    .toList(),
                onChosen: (newIndex) {
                  setState(() {
                    index = newIndex;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FormattedGrade extends StatelessWidget {
  FormattedGrade(this.data, {Key key});

  final String data;

  @override
  Widget build(BuildContext context) {
    if (data == '未知') {
      return Text(
        data,
        style: TextStyle(color: Color(0xFF9E9E9E)),
      );
    } else if (int.tryParse(data) != null && int.tryParse(data) < 60) {
      return Text(
        data,
        style: TextStyle(color: Colors.red),
      );
    } else {
      return Text(data);
    }
  }
}
