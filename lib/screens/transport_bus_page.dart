import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ccu_toolbox/controllers/transport_controller.dart';
import 'package:ccu_toolbox/models/transport/busstop.dart';
import 'package:ccu_toolbox/widgets/bounce_button.dart';
import 'package:ccu_toolbox/widgets/choose_menu_button.dart';
import 'package:ccu_toolbox/widgets/error_indicator.dart';

class TransportBusPage extends StatefulWidget {
  final busRoutes = TransportController.busRoutes;

  @override
  _TransportBusPageState createState() => _TransportBusPageState();
}

class _TransportBusPageState extends State<TransportBusPage>
    with AutomaticKeepAliveClientMixin {
  int index = 0;
  String route = '';
  String buttonText = '';
  String direction = '';
  List<Widget> items;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    items = routeItems;
    updateState(0);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SafeArea(
      child: Stack(
        children: [
          FutureBuilder<List<BusStop>>(
            future: TransportController.getBusStops(route, direction),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done)
                return Center(
                  child: SpinKitThreeBounce(
                    size: 20.0,
                    color: Colors.blue,
                    duration: Duration(milliseconds: 1200),
                  ),
                );
              if (snapshot.hasError) {
                switch (snapshot.error.runtimeType) {
                  case SocketException:
                    return Center(child: NetworkErrorIndicator());
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
                          Icons.nature_people_rounded,
                          color: Theme.of(context).textTheme.subtitle1.color,
                          size: 45.0,
                        ),
                        Text(
                          '目前沒有資料',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.subtitle1.color,
                            fontSize: 15.0,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            '更新時間: ' +
                                DateFormat('HH:mm:ss').format(DateTime.now()),
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .color),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: Timeline(
                            indicatorSize: 23.0,
                            gutterSpacing: 27.0,
                            lineGap: 0.0,
                            lineColor: Color(0xFFE8E8E8),
                            strokeWidth: 3.0,
                            itemGap: 35.0,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            physics: NeverScrollableScrollPhysics(),
                            children: snapshot.data.map((busStop) {
                              if (busStop.car.isEmpty)
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(busStop.name,
                                        style: TextStyle(fontSize: 18.0)),
                                    SizedBox(height: 2.0),
                                    Text(busStop.time,
                                        style: TextStyle(
                                            color: Color(0xFF9E9E9E),
                                            fontSize: 16.0)),
                                  ],
                                );
                              else
                                return Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(busStop.name,
                                              style: TextStyle(fontSize: 18.0)),
                                          SizedBox(height: 2.0),
                                          Text(busStop.time,
                                              style: TextStyle(
                                                  color: Color(0xFF9E9E9E),
                                                  fontSize: 16.0)),
                                        ],
                                      ),
                                    ),
                                    BusIcon(
                                      no: busStop.car,
                                      accessible: busStop.accessible,
                                    ),
                                  ],
                                );
                            }).toList(),
                            indicators: snapshot.data.map((busStop) {
                              if (busStop.car.isNotEmpty)
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFF5C6BC0),
                                      shape: BoxShape.circle),
                                );
                              if (busStop.time == '即將進站')
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFFFF7373),
                                      shape: BoxShape.circle),
                                );
                              if (busStop.time.contains('分') ||
                                  busStop.time.contains('時'))
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFF67AC4E),
                                      shape: BoxShape.circle),
                                );
                              if (busStop.time.contains(':'))
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFFFFB84F),
                                      shape: BoxShape.circle),
                                );
                              return Container(
                                decoration: BoxDecoration(
                                    color: Color(0xFF9E9E9E),
                                    shape: BoxShape.circle),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          height: 70.0,
                        ),
                      ],
                    ),
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
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: ChooseMenuButton(
                buttonText: buttonText,
                menuTitle: '路線',
                items: items,
                onChosen: (index) {
                  setState(() {
                    updateState(index);
                  });
                },
              ),
            ),
          ),
          Positioned(
            bottom: 15.0,
            right: 15.0,
            child: BounceButton(
              onTap: () {
                setState(() {});
              },
              child: Container(
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                    color: Color(0xFF3BA7F5),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset.fromDirection(1.5, 4),
                          blurRadius: 2.0,
                          color: Color.fromRGBO(0, 0, 0, 0.25))
                    ]),
                child: Icon(Icons.cached, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> get routeItems {
    List<Widget> result = [];

    widget.busRoutes.forEach((busRoute) {
      String routeNo = TransportController.busRouteNo(busRoute);
      String routeName = TransportController.busRouteName(busRoute);
      String from = TransportController.busRouteFrom(busRoute);
      String to = TransportController.busRouteTo(busRoute);
      result.add(Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SizedBox(
          height: 60.0,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$routeNo $routeName (往)',
                  style: TextStyle(
                    fontSize: 17.0,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  '$from --> $to',
                  style: TextStyle(fontSize: 12.0, color: Color(0xFF9E9E9E)),
                ),
              ],
            ),
          ),
        ),
      ));
      result.add(Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: SizedBox(
          height: 60.0,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$routeNo $routeName (返)',
                  style: TextStyle(
                    fontSize: 17.0,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  '$from <-- $to',
                  style: TextStyle(fontSize: 12.0, color: Color(0xFF9E9E9E)),
                ),
              ],
            ),
          ),
        ),
      ));
    });

    return result;
  }

  void updateState(int optionIndex) {
    route = widget.busRoutes[optionIndex ~/ 2];
    direction = optionIndex % 2 == 0 ? '1' : '2';
    String routeNo = TransportController.busRouteNo(route);
    String routeName = TransportController.busRouteName(route);
    buttonText = optionIndex % 2 == 0
        ? '$routeNo $routeName (往)'
        : '$routeNo $routeName (返)';
  }
}

class BusIcon extends StatelessWidget {
  BusIcon({
    Key key,
    this.no = '',
    this.accessible = false,
  });

  final String no;
  final bool accessible;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 35.0,
          width: 50.0,
          child: Stack(
            children: [
              Center(
                child: Icon(
                  Icons.directions_bus,
                  color: Colors.indigo[400],
                  size: 35.0,
                ),
              ),
              if (accessible)
                Positioned(
                  right: 0,
                  bottom: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.blue,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                    child: Icon(
                      Icons.accessible,
                      color: Colors.blue,
                      size: 15.0,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Container(
          width: 60.0,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
          ),
          alignment: Alignment.center,
          child: Text(
            no,
            style: TextStyle(fontSize: 12.0, color: Colors.black),
            softWrap: false,
          ),
        ),
      ],
    );
  }
}

// Belowing code is modified from https://stackoverflow.com/questions/49635381/flutter-create-a-timeline-ui

class Timeline extends StatelessWidget {
  const Timeline({
    @required this.children,
    this.indicators,
    this.isLeftAligned = true,
    this.itemGap = 12.0,
    this.gutterSpacing = 4.0,
    this.padding = const EdgeInsets.all(8),
    this.controller,
    this.lineColor = Colors.grey,
    this.physics,
    this.shrinkWrap = true,
    this.primary = false,
    this.reverse = false,
    this.indicatorSize = 30.0,
    this.lineGap = 4.0,
    this.indicatorColor = Colors.blue,
    this.indicatorStyle = PaintingStyle.fill,
    this.strokeCap = StrokeCap.butt,
    this.strokeWidth = 2.0,
    this.style = PaintingStyle.stroke,
  })  : itemCount = children.length,
        assert(itemGap >= 0),
        assert(lineGap >= 0),
        assert(indicators == null || children.length == indicators.length);

  final List<Widget> children;
  final double itemGap;
  final double gutterSpacing;
  final List<Widget> indicators;
  final bool isLeftAligned;
  final EdgeInsets padding;
  final ScrollController controller;
  final int itemCount;
  final ScrollPhysics physics;
  final bool shrinkWrap;
  final bool primary;
  final bool reverse;

  final Color lineColor;
  final double lineGap;
  final double indicatorSize;
  final Color indicatorColor;
  final PaintingStyle indicatorStyle;
  final StrokeCap strokeCap;
  final double strokeWidth;
  final PaintingStyle style;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      separatorBuilder: (_, __) => SizedBox(height: itemGap),
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: itemCount,
      controller: controller,
      reverse: reverse,
      primary: primary,
      itemBuilder: (context, index) {
        final child = children[index];

        Widget indicator;
        if (indicators != null) {
          indicator = indicators[index];
        }

        final isFirst = index == 0;
        final isLast = index == itemCount - 1;

        final timelineTile = <Widget>[
          CustomPaint(
            foregroundPainter: _TimelinePainter(
              hideDefaultIndicator: indicator != null,
              lineColor: lineColor,
              indicatorColor: indicatorColor,
              indicatorSize: indicatorSize,
              indicatorStyle: indicatorStyle,
              isFirst: isFirst,
              isLast: isLast,
              lineGap: lineGap,
              strokeCap: strokeCap,
              strokeWidth: strokeWidth,
              style: style,
              itemGap: itemGap,
            ),
            child: SizedBox(
              height: double.infinity,
              width: indicatorSize,
              child: indicator,
            ),
          ),
          SizedBox(width: gutterSpacing),
          Expanded(child: child),
        ];

        return IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children:
                isLeftAligned ? timelineTile : timelineTile.reversed.toList(),
          ),
        );
      },
    );
  }
}

class _TimelinePainter extends CustomPainter {
  _TimelinePainter({
    @required this.hideDefaultIndicator,
    @required this.indicatorColor,
    @required this.indicatorStyle,
    @required this.indicatorSize,
    @required this.lineGap,
    @required this.strokeCap,
    @required this.strokeWidth,
    @required this.style,
    @required this.lineColor,
    @required this.isFirst,
    @required this.isLast,
    @required this.itemGap,
  })  : linePaint = Paint()
          ..color = lineColor
          ..strokeCap = strokeCap
          ..strokeWidth = strokeWidth
          ..style = style,
        circlePaint = Paint()
          ..color = indicatorColor
          ..style = indicatorStyle;

  final bool hideDefaultIndicator;
  final Color indicatorColor;
  final PaintingStyle indicatorStyle;
  final double indicatorSize;
  final double lineGap;
  final StrokeCap strokeCap;
  final double strokeWidth;
  final PaintingStyle style;
  final Color lineColor;
  final Paint linePaint;
  final Paint circlePaint;
  final bool isFirst;
  final bool isLast;
  final double itemGap;

  @override
  void paint(Canvas canvas, Size size) {
    final indicatorRadius = indicatorSize / 2;
    final halfItemGap = itemGap / 2;
    final indicatorMargin = indicatorRadius + lineGap;

    final top = size.topLeft(Offset(indicatorRadius, 0.0 - halfItemGap));
    final centerTop = size.centerLeft(
      Offset(indicatorRadius, -indicatorMargin),
    );

    final bottom = size.bottomLeft(Offset(indicatorRadius, 0.0 + halfItemGap));
    final centerBottom = size.centerLeft(
      Offset(indicatorRadius, indicatorMargin),
    );

    if (!isFirst) canvas.drawLine(top, centerTop, linePaint);
    if (!isLast) canvas.drawLine(centerBottom, bottom, linePaint);

    if (!hideDefaultIndicator) {
      final Offset offsetCenter = size.centerLeft(Offset(indicatorRadius, 0));

      canvas.drawCircle(offsetCenter, indicatorRadius, circlePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
