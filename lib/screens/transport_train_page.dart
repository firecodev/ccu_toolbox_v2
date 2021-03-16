import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ccu_toolbox/controllers/transport_controller.dart';
import 'package:ccu_toolbox/models/transport/train.dart';
import 'package:ccu_toolbox/widgets/bounce_button.dart';
import 'package:ccu_toolbox/widgets/choose_menu_button.dart';
import 'package:ccu_toolbox/widgets/error_indicator.dart';

class TransportTrainPage extends StatefulWidget {
  final trainStations = TransportController.trainStations;

  @override
  _TransportTrainPageState createState() => _TransportTrainPageState();
}

class _TransportTrainPageState extends State<TransportTrainPage>
    with AutomaticKeepAliveClientMixin {
  int index = 0;
  String station = '';
  String buttonText = '';
  String direction = '';
  List<Widget> items;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    items = stationItems;
    updateState(0);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SafeArea(
      child: Stack(
        children: [
          FutureBuilder<List<Train>>(
            future: TransportController.getTrains(station, direction),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            '因API每日存取次數限制 請勿頻繁更新或切換車站',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 12.0,
                                color: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .color),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          shrinkWrap: true,
                          separatorBuilder: (_, __) => Divider(
                            height: 20.0,
                            thickness: 1.0,
                          ),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return LiveboardCard(train: snapshot.data[index]);
                          },
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
                menuTitle: '車站',
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

  List<Widget> get stationItems {
    List<Widget> result = [];

    widget.trainStations.forEach((trainStation) {
      String stationName = TransportController.trainStationName(trainStation);
      result.add(SizedBox(
        height: 50.0,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '$stationName火車站 (順行)',
            style: TextStyle(
              fontSize: 17.0,
            ),
          ),
        ),
      ));
      result.add(SizedBox(
        height: 50.0,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '$stationName火車站 (逆行)',
            style: TextStyle(
              fontSize: 17.0,
            ),
          ),
        ),
      ));
    });

    return result;
  }

  void updateState(int optionIndex) {
    station = widget.trainStations[optionIndex ~/ 2];
    direction = optionIndex % 2 == 0 ? '0' : '1';
    String stationName = TransportController.trainStationName(station);
    buttonText =
        optionIndex % 2 == 0 ? '$stationName火車站 (順行)' : '$stationName火車站 (逆行)';
  }
}

class LiveboardCard extends StatelessWidget {
  LiveboardCard({
    @required this.train,
  });

  final Train train;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          DateFormat('HH:mm').format(train.arrivalTime),
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(width: 15.0),
        Flexible(
          fit: FlexFit.tight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    train.name,
                    style: TextStyle(
                        color: trainFontColor[train.type], fontSize: 20.0),
                  ),
                  SizedBox(width: 5.0),
                  if (TransportController.trainAccessible(train.type))
                    Icon(Icons.accessible, color: Colors.grey),
                  if (TransportController.trainBike(train.type))
                    Icon(Icons.directions_bike, color: Colors.grey),
                  if (TransportController.trainChild(train.type))
                    Icon(Icons.child_care, color: Colors.grey),
                ],
              ),
              SizedBox(height: 5.0),
              Text(
                '#${train.no}',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 17.0,
                ),
              ),
            ],
          ),
        ),
        Container(
          child: train.delay >= 0 ? DelayChip(delayTime: train.delay) : null,
        ),
        SizedBox(
          width: 5.0,
        ),
        Row(
          children: [
            Text(
              '往',
              style: TextStyle(color: Colors.grey, fontSize: 15.0),
            ),
            Text(
              ' ${train.to}',
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 15.0),
            ),
          ],
        ),
      ],
    );
  }
}

class DelayChip extends StatelessWidget {
  DelayChip({
    @required this.delayTime,
  });

  final int delayTime;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        delayTime == 0 ? '準點' : '晚$delayTime分',
        style: TextStyle(color: Colors.white, height: 1.25),
      ),
      backgroundColor: delayTime == 0 ? Colors.green : Colors.red,
    );
  }
}

Map<String, Color> trainFontColor = {
  '1101': Colors.orange[600], //自強(太，障)
  '1105': Colors.orange[600],
  '1104': Colors.orange[600],
  '1112': Color.fromRGBO(230, 105, 80, 1),
  '1131': Colors.blue[800],
  '1132': Colors.blue[800],
  '1111': Color.fromRGBO(230, 105, 80, 1), //莒光(障)
  '1103': Colors.orange[600], //自強(障)
  '1102': Colors.orange[600], //自強(腳，障)
  '1100': Colors.orange[600],
  '1110': Color.fromRGBO(230, 105, 80, 1),
  '1113': Color.fromRGBO(230, 105, 80, 1),
  '1107': Color.fromRGBO(230, 80, 130, 1), //自強(普，障)
  '1135': Colors.blue[800], //區間車(腳，障)
  '1108': Colors.orange[600], //自強(PP障)
  '1114': Color.fromRGBO(230, 105, 80, 1), //莒光(腳)
  '1115': Color.fromRGBO(230, 105, 80, 1), //莒光(腳，障)
  '1109': Colors.orange[600], //自強(PP親)
  '110A': Colors.orange[600], //自強(PP障12)
  '110B': Colors.orange[600], //自強(E12)
  '110C': Colors.orange[600], //自強(E3)
  '110D': Colors.orange[600], //自強(D28)
  '110E': Colors.orange[600], //自強(D29)
  '110F': Colors.orange[600], //自強(D31)
  '1106': Colors.orange[600],
};
