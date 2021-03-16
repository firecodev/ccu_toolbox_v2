import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:ccu_toolbox/controllers/ecourse2_controller.dart';
import 'package:ccu_toolbox/helper/shared_preferences_helper.dart';
import 'package:ccu_toolbox/widgets/minimal_scaffold.dart';
import 'package:ccu_toolbox/widgets/bounce_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key key, this.redirect});

  final String redirect;

  @override
  Widget build(BuildContext context) {
    return MinimalScaffold(
      title: '登入',
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'CCU\nToolbox',
                  style: TextStyle(
                    color: Color(0xFF3BA7F5),
                    fontSize: 32.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: LoginForm(redirect: redirect),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 17.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    '此登入適用於:\n教務系統 & eCourse2',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.subtitle1.color,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  LoginForm({Key key, this.redirect});

  final String redirect;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _verify = true;
  bool _obscureText = true;
  bool _isLoading = false;
  String _username = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: Text(
                '學號',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
              style:
                  TextStyle(color: Theme.of(context).textTheme.bodyText2.color),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).textTheme.subtitle1.color),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF00C2FF)),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              validator: (value) {
                if (value.trim().isEmpty) {
                  return '學號不能留白哦~';
                }
                if (value.length != 9) {
                  return '學號需為9個字元';
                }
                return null;
              },
              onSaved: (value) {
                _username = value;
              },
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: Text(
                '密碼',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
              keyboardType: TextInputType.visiblePassword,
              obscureText: _obscureText,
              enableSuggestions: false,
              autocorrect: false,
              style:
                  TextStyle(color: Theme.of(context).textTheme.bodyText2.color),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).textTheme.subtitle1.color),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF00C2FF)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: Theme.of(context).textTheme.subtitle1.color,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )),
              validator: (value) {
                if (value.isEmpty) {
                  return '密碼不能留白哦~';
                }
                if (value.length < 4 || value.length > 10) {
                  return '密碼長度介於4~10個字元';
                }
                return null;
              },
              onSaved: (value) {
                _password = value;
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                FocusScope.of(context).unfocus();
                _verify = !_verify;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularCheckBox(
                      inactiveColor:
                          Theme.of(context).textTheme.subtitle1.color,
                      activeColor: Color(0xFF3BA7F5),
                      value: _verify,
                      onChanged: (_) {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          _verify = !_verify;
                        });
                      }),
                  Text(
                    '進行驗證 (不適用離線狀態)',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: _isLoading
                ? Center(
                    child: SpinKitThreeBounce(
                      size: 15.0,
                      color: Colors.blue,
                      duration: Duration(milliseconds: 1200),
                    ),
                  )
                : BounceButton(
                    onTap: () {
                      if (_formKey.currentState.validate()) {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          _isLoading = true;
                        });
                        submit();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Color(0xFF3BA7F5),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset.fromDirection(1.5, 3),
                              blurRadius: 3.0,
                              color: Color.fromRGBO(0, 0, 0, 0.25))
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 25.0),
                        child: Text(
                          '登入',
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> submit() async {
    try {
      _formKey.currentState.save();
      if (_verify) {
        await verifyLogin(_username, _password);
      }
      await SharedPreferencesHelper.versionChecker();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', _username);
      await prefs.setString('password', _password);
      if (widget.redirect != null)
        Navigator.pushReplacementNamed(context, widget.redirect);
      else
        Navigator.pop(context);
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
        title: Text('驗證失敗'),
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
}
