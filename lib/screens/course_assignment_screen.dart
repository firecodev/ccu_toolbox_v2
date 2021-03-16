import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;
import 'package:ccu_toolbox/models/ecourse2/assignment.dart';
import 'package:ccu_toolbox/widgets/minimal_scaffold.dart';

class CourseAssignmentScreen extends StatelessWidget {
  CourseAssignmentScreen({Key key, @required this.assignment});

  final Assignment assignment;

  @override
  Widget build(BuildContext context) {
    return MinimalScaffold(
      title: assignment.name,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 8.0),
                  child: Text(
                    assignment.name,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!assignment.startTime.isAtSameMomentAs(
                          DateTime.fromMillisecondsSinceEpoch(0)))
                        Text(
                          '開放: ' +
                              DateFormat('yyyy-MM-dd HH:mm')
                                  .format(assignment.startTime),
                          style: TextStyle(
                            color: Color(0xFF8A8A8A),
                            fontSize: 15.0,
                          ),
                        ),
                      if (!assignment.dueTime.isAtSameMomentAs(
                          DateTime.fromMillisecondsSinceEpoch(0)))
                        Text(
                          '遲交: ' +
                              DateFormat('yyyy-MM-dd HH:mm')
                                  .format(assignment.dueTime),
                          style: TextStyle(
                            color: Color(0xFF8A8A8A),
                            fontSize: 15.0,
                          ),
                        ),
                      if (!assignment.cutoffTime.isAtSameMomentAs(
                          DateTime.fromMillisecondsSinceEpoch(0)))
                        Text(
                          '關閉: ' +
                              DateFormat('yyyy-MM-dd HH:mm')
                                  .format(assignment.cutoffTime),
                          style: TextStyle(
                            color: Color(0xFF8A8A8A),
                            fontSize: 15.0,
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Html(
                    data: assignment.intro,
                    onImageTap: (url) {
                      _launchURL(url);
                    },
                    onLinkTap: (url) {
                      _launchURL(url);
                    },
                    customRender: {
                      'video': (context, child, attributes, element) => Text(
                            '不支援影片預覽，請至 eCourse2 網頁版觀看。',
                            style: TextStyle(
                              color: Color(0xFF8A8A8A),
                              fontSize: 12.0,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                    },
                  ),
                ),
                if (assignment.files.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            '附加檔案',
                            style: TextStyle(
                              color: Color(0xFF8A8A8A),
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: assignment.files
                              .map((e) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        _launchURL(e.url);
                                      },
                                      child: Text(
                                        e.filename,
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  ))
                              .toList(),
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

_launchURL(String url) async {
  if (await urlLauncher.canLaunch(url)) {
    await urlLauncher.launch(url);
  }
}
