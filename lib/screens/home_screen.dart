import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ccu_toolbox/widgets/bounce_button.dart';

class HomeScreen extends StatelessWidget {
  final pageViewController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Column(
                children: [
                  Flexible(
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 20, child: SizedBox.expand()),
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: Image(
                                alignment: Alignment.centerLeft,
                                image: AssetImage(
                                    'lib/assets/images/pineapple.png'),
                              ),
                            ),
                            Expanded(flex: 5, child: SizedBox.expand()),
                            Text(
                              'CCU\nToolbox',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30),
                            ),
                            Expanded(flex: 25, child: SizedBox.expand()),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      child: PageView(
                        controller: pageViewController,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 110,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _AppButton(
                                        title: 'eCourse2',
                                        icon: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFF3682D9),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7.0)),
                                          ),
                                          clipBehavior: Clip.hardEdge,
                                          child: Icon(
                                            Icons.school_rounded,
                                            color: Colors.white,
                                            size: 35.0,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/ecourse2home');
                                        },
                                      ),
                                      _AppButton(
                                        title: '課表',
                                        icon: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFEDA724),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7.0)),
                                          ),
                                          clipBehavior: Clip.hardEdge,
                                          child: Icon(
                                            Icons.assignment_rounded,
                                            color: Colors.white,
                                            size: 35.0,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/timetable');
                                        },
                                      ),
                                      _AppButton(
                                        title: '交通',
                                        icon: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFF00A113),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7.0)),
                                          ),
                                          clipBehavior: Clip.hardEdge,
                                          child: Icon(
                                            Icons.commute_rounded,
                                            color: Colors.white,
                                            size: 35.0,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/transport');
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 110,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _AppButton(
                                        title: '行事曆',
                                        icon: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFE04171),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7.0)),
                                          ),
                                          clipBehavior: Clip.hardEdge,
                                          child: Icon(
                                            Icons.event_note_rounded,
                                            color: Colors.white,
                                            size: 35.0,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/schedule');
                                        },
                                      ),
                                      _AppButton(
                                        title: '成績查詢',
                                        icon: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.brown,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7.0)),
                                          ),
                                          clipBehavior: Clip.hardEdge,
                                          child: Icon(
                                            Icons.book_rounded,
                                            color: Colors.white,
                                            size: 35.0,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/grade');
                                        },
                                      ),
                                      _AppButton(
                                        title: '設定',
                                        icon: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFF877FA1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7.0)),
                                          ),
                                          clipBehavior: Clip.hardEdge,
                                          child: Icon(
                                            Icons.settings_rounded,
                                            color: Colors.white,
                                            size: 35.0,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/setting');
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 110,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _AppButton(
                                        title: '關於',
                                        icon: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFF525252),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7.0)),
                                          ),
                                          clipBehavior: Clip.hardEdge,
                                          child: Icon(
                                            Icons.info_rounded,
                                            color: Colors.white,
                                            size: 35.0,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/about');
                                        },
                                      ),
                                      SizedBox(
                                        height: 68,
                                        width: 68,
                                      ),
                                      SizedBox(
                                        height: 68,
                                        width: 68,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 110,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset.fromDirection(1.5, 4),
                            blurRadius: 2.0,
                            color: Color.fromRGBO(0, 0, 0, 0.25))
                      ]),
                  child: Material(
                    color: Theme.of(context).backgroundColor,
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                      },
                      child: Row(
                        children: [
                          AspectRatio(
                            aspectRatio: 1 / 1,
                            child: Icon(Icons.chat_rounded),
                          ),
                          Text(
                            '歡迎使用 CCU Toolbox v2 ~',
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class _AppButton extends StatelessWidget {
  _AppButton({@required this.title, @required this.icon, this.onTap});

  final String title;
  final Widget icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return BounceButton(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 68,
              width: 68,
              child: icon,
            ),
            SizedBox(height: 10),
            Text(title),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
