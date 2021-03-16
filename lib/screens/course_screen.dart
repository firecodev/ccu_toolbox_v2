import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ccu_toolbox/widgets/minimal_scaffold.dart';
import 'package:ccu_toolbox/widgets/minimal_tab_bar.dart';
import 'package:ccu_toolbox/models/course.dart';
import 'course_announcement_page.dart';
import 'course_assignment_page.dart';
import 'course_score_page.dart';
import 'course_file_page.dart';

class CourseScreen extends StatelessWidget {
  CourseScreen({Key key, @required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: course,
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
  static final List<String> items = <String>['公告', '作業', '成績', '檔案'];

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
      title: context.read<Course>().name,
      body: Column(
        children: [
          MinimalTabBar(
            tabController: _tabController,
            tabs: tabs,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 9.0),
              child: TabBarView(
                controller: _tabController,
                children: [
                  CourseAnnouncementPage(),
                  CourseAssignmentPage(),
                  CourseScorePage(),
                  CourseFilePage(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
