import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ccu_toolbox/controllers/ecourse2_controller.dart';
import 'package:ccu_toolbox/models/course.dart';
import 'package:ccu_toolbox/models/ecourse2/file.dart';
import 'package:ccu_toolbox/widgets/bounce_button.dart';
import 'package:ccu_toolbox/widgets/error_indicator.dart';

class CourseFilePage extends StatefulWidget {
  @override
  _CourseFilePageState createState() => _CourseFilePageState();
}

class _CourseFilePageState extends State<CourseFilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SafeArea(
        child: FutureBuilder<List<Ecourse2FileList>>(
      future: context
          .read<Ecourse2Controller>()
          .getFileLists(context.read<Course>()),
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
                    '目前沒有檔案',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.subtitle1.color,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          snapshot.data[index].title,
                          style: TextStyle(
                            color: Color(0xFF9E9E9E),
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 1.0,
                      ),
                      ...snapshot.data[index].files
                          .map((file) => _FileCard(
                                file: file,
                              ))
                          .toList()
                    ],
                  ),
                );
              },
              itemCount: snapshot.data.length,
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
    ));
  }
}

class _FileCard extends StatelessWidget {
  _FileCard({this.file});

  final Ecourse2File file;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 13.0),
      child: BounceButton(
        onTap: () {
          _launchURL(file.url);
        },
        child: Container(
          width: double.infinity,
          height: 73.0,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border:
                Border.all(color: Theme.of(context).textTheme.subtitle1.color),
            borderRadius: BorderRadius.circular(13.0),
            boxShadow: [
              BoxShadow(
                  offset: Offset.fromDirection(1.5, 2),
                  blurRadius: 1.5,
                  color: Color.fromRGBO(0, 0, 0, 0.07))
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  style: TextStyle(fontSize: 17.0),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
                SizedBox(height: 5.0),
                Text(
                  '${file.filename} / ${_filesizeFormat(file.size)}',
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  maxLines: 1,
                  style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _filesizeFormat(int filesize) {
  double tempSize = filesize.toDouble();
  String unit = 'B';
  if (tempSize > 1024) {
    unit = 'KB';
    tempSize /= 1024;
  }
  if (tempSize > 1024) {
    unit = 'MB';
    tempSize /= 1024;
  }
  if (tempSize > 1024) {
    unit = 'GB';
    tempSize /= 1024;
  }
  if (tempSize > 1024) {
    unit = 'TB';
    tempSize /= 1024;
  }
  return '${tempSize.toStringAsFixed(1)} $unit';
}

_launchURL(String url) async {
  if (await urlLauncher.canLaunch(url)) {
    await urlLauncher.launch(url);
  }
}
