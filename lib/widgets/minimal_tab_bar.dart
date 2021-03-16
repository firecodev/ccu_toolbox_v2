import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MinimalTabBar extends StatelessWidget {
  MinimalTabBar({Key key, @required this.tabController, @required this.tabs});

  final TabController tabController;
  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        child: Theme(
          data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent),
          child: TabBar(
            onTap: (index) {
              HapticFeedback.lightImpact();
            },
            controller: tabController,
            tabs: tabs,
            unselectedLabelColor: Color(0xFF3BA7F5),
            labelPadding: EdgeInsets.zero,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color(0xFF3BA7F5),
              boxShadow: [
                BoxShadow(
                    offset: Offset.fromDirection(1.5, 3),
                    blurRadius: 3.0,
                    color: Color.fromRGBO(0, 0, 0, 0.25))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
