import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ccu_toolbox/environments/transport_param.dart';
import 'package:ccu_toolbox/models/transport/busstop.dart';
import 'package:ccu_toolbox/models/transport/train.dart';

class TransportController {
  /* ===== Bus ===== */

  static List<String> get busRoutes => getBusRoutes;

  static String busRouteNo(String route) => getBusRouteNo(route);

  static String busRouteName(String route) => getBusRouteName(route);

  static String busRouteFrom(String route) => getBusRouteFrom(route);

  static String busRouteTo(String route) => getBusRouteTo(route);

  static Future<List<BusStop>> getBusStops(
      String route, String direction) async {
    List<BusStop> busStops = [];

    try {
      final response = await http.get(
        getTransportUrl('bus') +
            '?routeNo=$route&branch=0&goBack=$direction&Source=w',
        headers: {
          'User-Agent': getUserAgent,
        },
      );

      final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

      final stopList = (decodedResponse as List).first['stopInfo'] as List;

      /* Convert to BusStop object */
      String previousCar = '';
      stopList.forEach((stop) {
        if (stop['carNo'] == previousCar) {
          busStops.add(BusStop(
            name: stop['name'],
            time: stop['predictionTime'],
          ));
        } else {
          previousCar = stop['carNo'];
          busStops.add(BusStop(
            name: stop['name'],
            time: stop['predictionTime'],
            car: previousCar,
            accessible: stop['carLow'] == 'Y',
          ));
        }
      });
    } catch (err) {
      throw err;
    }

    return busStops;
  }

  /* ===== Train ===== */

  static List<String> get trainStations => getTrainStations;

  static String trainStationName(String station) =>
      getTrainStationName(station);

  static bool trainAccessible(String train) => isTrainAccessible(train);

  static bool trainBike(String train) => isTrainBike(train);

  static bool trainChild(String train) => isTrainChild(train);

  static Future<List<Train>> getTrains(String station, String direction) async {
    List<Train> trains;

    try {
      final nowDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final nowDateTime = DateTime.now();

      /* Get live board info */
      var response = await http.get(
        getTransportUrl('trainLiveBoard') +
            '$station?\$filter=Direction%20eq%20$direction&\$format=JSON',
        headers: {
          'User-Agent': getUserAgent,
        },
      );

      final decodedResponse =
          jsonDecode(utf8.decode(response.bodyBytes)) as List;

      Map<String, int> trainDelayMap = {};

      decodedResponse.forEach((train) {
        trainDelayMap[train['TrainNo']] = train['DelayTime'];
      });

      /* Get daily train info */
      response = await http.get(
        getTransportUrl('trainDailyTimetable') +
            '$station/$nowDate?\$filter=Direction%20eq%20$direction&\$format=JSON',
        headers: {
          'User-Agent': getUserAgent,
        },
      );

      final utf8Response = utf8.decode(response.bodyBytes);

      /* Convert to Train object */
      Map<String, dynamic> param = {
        'utf8Response': utf8Response,
        'trainDelayMap': trainDelayMap,
        'nowDate': nowDate,
        'nowDateTime': nowDateTime,
      };
      trains = await compute(parseTrainData, param);
    } catch (err) {
      throw err;
    }

    return trains;
  }
}

List<Train> parseTrainData(Map<String, dynamic> param) {
  String response = param['utf8Response'];
  Map<String, int> trainDelayMap = param['trainDelayMap'];
  String nowDate = param['nowDate'];
  DateTime nowDateTime = param['nowDateTime'];

  List<Train> trains = [];

  final decodedResponse = jsonDecode(response) as List;

  /* Convert to Train object */
  decodedResponse.forEach((train) {
    String trainNo = train['TrainNo'];
    DateTime arrivalTime =
        DateTime.tryParse('$nowDate ${train['ArrivalTime']}:00');
    DateTime depatureTime =
        DateTime.tryParse('$nowDate ${train['DepartureTime']}:00');
    if ((train['DepartureTime'] as String)
            .compareTo(train['ArrivalTime'] as String) <
        0) {
      // cross day correction
      arrivalTime = arrivalTime.subtract(Duration(days: 1));
    }
    if (trainDelayMap.containsKey(trainNo)) {
      if (!depatureTime
          .add(Duration(minutes: trainDelayMap[trainNo]))
          .isBefore(nowDateTime)) {
        trains.add(Train(
          no: trainNo,
          name: getTrainName(train['TrainTypeID']) ?? '未知',
          type: train['TrainTypeID'],
          to: (train['EndingStationName'] as Map)['Zh_tw'],
          arrivalTime: arrivalTime,
          delay: trainDelayMap[trainNo],
        ));
      }
    } else {
      if (!depatureTime.isBefore(nowDateTime)) {
        trains.add(Train(
          no: trainNo,
          name: getTrainName(train['TrainTypeID']) ?? '未知',
          type: train['TrainTypeID'],
          to: (train['EndingStationName'] as Map)['Zh_tw'],
          arrivalTime: arrivalTime,
        ));
      }
    }
  });

  return trains;
}
