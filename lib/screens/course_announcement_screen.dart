import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;
import 'package:ccu_toolbox/models/ecourse2/announcement.dart';
import 'package:ccu_toolbox/widgets/minimal_scaffold.dart';

class CourseAnnouncementScreen extends StatelessWidget {
  CourseAnnouncementScreen({Key key, @required this.announcement});

  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    return MinimalScaffold(
      title: announcement.subject,
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
                    announcement.subject,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Text(
                        announcement.creatorname,
                        style: TextStyle(
                          color: Color(0xFF8A8A8A),
                          fontSize: 15.0,
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Text(
                        DateFormat('yyyy-MM-dd HH:mm')
                            .format(announcement.createdTime),
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
                      data: announcement.content,
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
                      }),
                ),
                if (announcement.files.isNotEmpty)
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
                          children: announcement.files
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
