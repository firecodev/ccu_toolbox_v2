import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ccu_toolbox/controllers/kiki_controller.dart';
import 'package:ccu_toolbox/models/course.dart';
import 'package:ccu_toolbox/widgets/minimal_scaffold.dart';
import 'package:ccu_toolbox/widgets/minimal_tab_bar.dart';
import 'package:ccu_toolbox/widgets/error_indicator.dart';
import 'timetable_day_page.dart';
import 'timetable_week_page.dart';

class TimetableScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => KikiController(),
      child: _BuildScreen(),
    );
  }
}

class _BuildScreen extends StatefulWidget {
  @override
  __BuildScreenState createState() => __BuildScreenState();
}

class __BuildScreenState extends State<_BuildScreen>
    with SingleTickerProviderStateMixin {
  static final List<String> items = <String>['每日', '每週'];

  static final List<Tab> tabs = items
      .map<Tab>((item) => Tab(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 19.0),
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
    _tabController = TabController(vsync: this, length: tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MinimalScaffold(
      title: '課表',
      body: Column(
        children: [
          MinimalTabBar(
            tabController: _tabController,
            tabs: tabs,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 9.0),
              child: StreamBuilder<List<List<Course>>>(
                stream: context.read<KikiController>().getCoursesByWeekday,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    switch (snapshot.error.runtimeType) {
                      case SocketException:
                        return Center(child: NetworkErrorIndicator());
                        break;
                      case LoginException:
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          Navigator.pushReplacementNamed(context, '/login',
                              arguments: '/timetable');
                        });
                        return Center(child: LoginErrorIndicator());
                        break;
                      case SessionIdException:
                        return Center(child: TryAgainIndicator());
                        break;
                      default:
                        return Center(child: UnknownErrorIndicator());
                    }
                  } else if (snapshot.hasData) {
                    return TabBarView(
                      key: Key('hasData'),
                      controller: _tabController,
                      children: [
                        TimetableDayPage(
                          coursesList: snapshot.data,
                          isLoading: false,
                        ),
                        TimetableWeekPage(coursesList: snapshot.data),
                      ],
                    );
                  } else {
                    return TabBarView(
                      key: Key('loading'),
                      controller: _tabController,
                      children: [
                        TimetableDayPage(
                          coursesList: [[], [], [], [], [], [], [], []],
                          isLoading: true,
                        ),
                        Center(
                          child: SpinKitThreeBounce(
                            size: 20.0,
                            color: Colors.blue,
                            duration: Duration(milliseconds: 1200),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
