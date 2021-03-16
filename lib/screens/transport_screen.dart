import 'package:flutter/material.dart';
import 'transport_bus_page.dart';
import 'transport_train_page.dart';
import 'package:ccu_toolbox/widgets/minimal_scaffold.dart';
import 'package:ccu_toolbox/widgets/minimal_tab_bar.dart';

class TransportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _BuildScreen();
  }
}

class _BuildScreen extends StatefulWidget {
  @override
  __BuildScreenState createState() => __BuildScreenState();
}

class __BuildScreenState extends State<_BuildScreen>
    with SingleTickerProviderStateMixin {
  static final List<String> items = <String>['公車', '火車'];

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
      title: '交通概況',
      body: Column(children: [
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
                TransportBusPage(),
                TransportTrainPage(),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
