import 'package:flutter/material.dart';
import 'package:ccu_toolbox/widgets/minimal_scaffold.dart';
import 'package:ccu_toolbox/environments/app_info.dart' as appInfo;

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MinimalScaffold(
      title: '關於',
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_Info()],
          ),
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.0),
        Text('CCU Toolbox', style: TextStyle(fontSize: 32.0)),
        SizedBox(height: 4.0),
        Text('Version : ${appInfo.version}', style: TextStyle(fontSize: 17.0)),
        SizedBox(height: 16.0),
        Text('Build Date : ${appInfo.buildDate}',
            style: TextStyle(fontSize: 17.0)),
        Text('Flutter SDK Ver. : ${appInfo.flutterVersion}',
            style: TextStyle(fontSize: 17.0)),
        Text('行事曆版本 : ${appInfo.scheduleVersion}',
            style: TextStyle(fontSize: 17.0)),
        SizedBox(height: 16.0),
        Row(
          children: [
            Text('Made with ', style: TextStyle(fontSize: 17.0)),
            Icon(Icons.favorite, color: Colors.red, size: 17.0),
            Text(' by Firecodev', style: TextStyle(fontSize: 17.0)),
          ],
        ),
      ],
    );
  }
}
