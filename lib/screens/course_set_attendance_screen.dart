import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ccu_toolbox/controllers/ecourse2_controller.dart';
import 'home_screen.dart';
import 'package:ccu_toolbox/widgets/slide_page_transition.dart';
import 'package:ccu_toolbox/widgets/minimal_scaffold.dart';
import 'package:ccu_toolbox/widgets/bounce_button.dart';

class CourseSetAttendanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _BuildScreen();
  }
}

class _BuildScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MinimalScaffold(
      title: '點名',
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '課程名稱',
                          style: TextStyle(
                              fontSize: 16.0, color: Color(0xFFCBCBCB)),
                        ),
                        SizedBox(height: 7.0),
                        Text(
                          '當前國內外情勢分析',
                          style: TextStyle(fontSize: 22.0),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '日期',
                          style: TextStyle(
                              fontSize: 16.0, color: Color(0xFFCBCBCB)),
                        ),
                        SizedBox(height: 7.0),
                        Text(
                          '2020/11/30 14:50',
                          style: TextStyle(fontSize: 22.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ActionForm(),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionForm extends StatefulWidget {
  @override
  _ActionFormState createState() => _ActionFormState();
}

class _ActionFormState extends State<ActionForm> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isLoading
          ? SpinKitThreeBounce(
              size: 15.0,
              color: Colors.blue,
              duration: Duration(milliseconds: 1200),
            )
          : _ActionButton(
              text: '登記出席',
              color: Color(0xFF0FB73E),
              onTap: () {
                setState(() {
                  _isLoading = true;
                });
                submit();
              },
            ),
    );
  }

  Future<void> submit() async {
    try {
      await Future.delayed(Duration(seconds: 1));
      // throw MoodleException('invalid session id');
      _showSuccessDialog('點名已記錄為"出席"');
    } catch (err) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        switch (err.runtimeType) {
          case SocketException:
            _showErrorDialog('網路連線錯誤');
            break;
          case LoginException:
            _showErrorDialog('帳號密碼錯誤');
            break;
          case MoodleException:
            _showErrorDialog('Moodle請求錯誤');
            break;
          default:
            _showErrorDialog('未知的錯誤');
        }
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('點名失敗'),
        content: Text(
          message,
          style: TextStyle(color: Color(0xFF636363)),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('點名完成'),
        content: Text(
          message,
          style: TextStyle(color: Color(0xFF636363)),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.pushReplacement(
                  context, SlidePageTransition(widget: HomeScreen()));
            },
          )
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  _ActionButton({@required this.text, @required this.color, this.onTap});

  final String text;
  final Color color;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return BounceButton(
      onTap: onTap,
      child: Container(
        height: 50.0,
        width: 130.0,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(13.0),
          boxShadow: [
            BoxShadow(
                offset: Offset.fromDirection(1.5, 2),
                blurRadius: 1.5,
                color: Color.fromRGBO(0, 0, 0, 0.20))
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 21.0),
          ),
        ),
      ),
    );
  }
}
