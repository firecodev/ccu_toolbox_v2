import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ccu_toolbox/controllers/setting_controller.dart';
import 'package:ccu_toolbox/widgets/minimal_scaffold.dart';
import 'package:ccu_toolbox/widgets/bounce_button.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({Key key});

  @override
  Widget build(BuildContext context) {
    return MinimalScaffold(
      title: '設定',
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: 36.0,
                        color: Color(0xFF119BFF),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        '帳號',
                        style: TextStyle(fontSize: 22.0),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 13.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 13.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '教務系統 & eCourse2',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .color,
                                  fontSize: 14.0),
                            ),
                            AccountCard(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 35.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.offline_bolt,
                        size: 36.0,
                        color: Color(0xFF119BFF),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        '介面',
                        style: TextStyle(fontSize: 22.0),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 13.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 50.0,
                              child: Row(
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '介面主題',
                                        style: TextStyle(fontSize: 17.0),
                                      ),
                                      Text(
                                        '重啟後生效',
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontStyle: FontStyle.italic,
                                            color: Theme.of(context)
                                                .textTheme
                                                .subtitle1
                                                .color),
                                      )
                                    ],
                                  ),
                                  Expanded(child: SizedBox()),
                                  FutureBuilder<AppTheme>(
                                      future: SettingController.getAppTheme(),
                                      builder: (ctx, snapshot) {
                                        if (snapshot.hasData) {
                                          return ThemeChip(
                                              initIndex: snapshot.data.index);
                                        } else {
                                          return SizedBox();
                                        }
                                      })
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 35.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.build_circle,
                        size: 36.0,
                        color: Color(0xFF119BFF),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        '雜項',
                        style: TextStyle(fontSize: 22.0),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 13.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '清除離線課表',
                                  style: TextStyle(fontSize: 17.0),
                                ),
                                Expanded(child: SizedBox()),
                                BounceButton(
                                  onTap: () {
                                    SettingController.clearCourseDatabase();
                                  },
                                  child: Chip(
                                    backgroundColor: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .color,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 15.0),
                                    label: Text(
                                      '清除',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17.0,
                                          height: 1.25),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountCard extends StatefulWidget {
  @override
  _AccountCardState createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38.0,
      child: FutureBuilder<String>(
          future: SettingController.getAccountUsername(),
          builder: (ctx, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '未知的錯誤',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.subtitle1.color,
                      fontSize: 17.0),
                ),
              );
            } else if (snapshot.hasData) {
              if (snapshot.data.isEmpty) {
                return Row(
                  children: [
                    Text(
                      '尚未登入',
                      style: TextStyle(
                          fontSize: 17.0,
                          color: Theme.of(context).textTheme.subtitle1.color),
                    ),
                    Expanded(child: SizedBox()),
                    BounceButton(
                      onTap: () async {
                        await Navigator.pushNamed(context, '/login');
                        setState(() {});
                      },
                      child: Chip(
                        backgroundColor: Color(0xFF00AF12),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 15.0),
                        label: Text(
                          '登入',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              height: 1.25),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Row(
                  children: [
                    Text(
                      snapshot.data,
                      style: TextStyle(fontSize: 17.0),
                    ),
                    Expanded(child: SizedBox()),
                    BounceButton(
                      onTap: () async {
                        await SettingController.deleteAccount();
                        setState(() {});
                      },
                      child: Chip(
                        backgroundColor: Color(0xFFFF5E5E),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 15.0),
                        label: Text(
                          '登出',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              height: 1.25),
                        ),
                      ),
                    )
                  ],
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
          }),
    );
  }
}

class ThemeChip extends StatefulWidget {
  final List<String> themes = [
    '系統',
    '透亮',
    '消暗',
  ];

  ThemeChip({this.initIndex = 0});

  final int initIndex;

  @override
  _ThemeChipState createState() => _ThemeChipState(index: initIndex);
}

class _ThemeChipState extends State<ThemeChip> {
  _ThemeChipState({this.index = 0});

  int index;

  @override
  Widget build(BuildContext context) {
    return ChooseMenuChip(
      buttonText: widget.themes[index],
      menuTitle: '主題',
      items: widget.themes
          .map((theme) => SizedBox(
                height: 45.0,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    theme,
                    style: TextStyle(fontSize: 17.0),
                  ),
                ),
              ))
          .toList(),
      onChosen: (newIndex) {
        index = newIndex;
        SettingController.setAppTheme(AppTheme.values[index]);
        setState(() {});
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20.0),
                  topRight: const Radius.circular(20.0),
                ),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 15.0, left: 12.0, right: 12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '提示',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 15.0),
                      Text(
                        '重新啟動程式後生效',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 15.0),
                      BounceButton(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SizedBox(
                          height: 30.0,
                          child: Center(
                            child: Text(
                              '確定',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Color(0xFF3BA7F5),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ChooseMenuChip extends StatelessWidget {
  ChooseMenuChip({
    Key key,
    this.buttonText = '',
    this.menuTitle = '',
    this.items = const [],
    this.onChosen,
  });

  final String buttonText;
  final String menuTitle;
  final List<Widget> items;
  final void Function(int index) onChosen;

  @override
  Widget build(BuildContext context) {
    return BounceButton(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20.0),
                  topRight: const Radius.circular(20.0),
                ),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 12.0),
                      child: Text(
                        menuTitle,
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (_, index) => BounceButton(
                        onTap: () {
                          Navigator.pop(context);
                          if (onChosen != null) onChosen(index);
                        },
                        child: items[index],
                      ),
                      separatorBuilder: (_, __) => Divider(
                        height: 1.0,
                        thickness: 1.0,
                      ),
                    ),
                    SizedBox(height: 15.0),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Chip(
        backgroundColor: Color(0xFF039BE5),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
        label: Text(
          buttonText,
          style: TextStyle(color: Colors.white, fontSize: 17.0, height: 1.25),
        ),
      ),
    );
  }
}
