// 列車代號及其他資訊: https://ods.railway.gov.tw/tra-ods-web/ods#services

String get getUserAgent => 'Mozilla/5.0';

const Map<String, String> _urls = {
  'bus': 'https://www.taiwanbus.tw/app_api/SP_PredictionTime_V3.ashx',
  'trainLiveBoard':
      'https://ptx.transportdata.tw/MOTC/v2/Rail/TRA/LiveBoard/Station/',
  'trainDailyTimetable':
      'https://ptx.transportdata.tw/MOTC/v2/Rail/TRA/DailyTimetable/Station/',
};

String getTransportUrl(String index) => _urls[index];

/* ===== Bus ===== */

const List<String> _busRoutes = [
  '0746',
  '7309',
  '7306',
  '6187',
  '7005',
];

const Map<String, String> _busRouteNo = {
  '0746': '106',
  '7309': '7309',
  '7306': '7306',
  '6187': '6187',
  '7005': '7005',
};

const Map<String, String> _busRouteName = {
  '0746': '嘉義縣公車',
  '7309': '嘉義縣公車',
  '7306': '嘉義縣公車',
  '6187': '台中客運',
  '7005': '日統客運',
};

const Map<String, String> _busRouteFrom = {
  '0746': '嘉義火車站',
  '7309': '大雅站',
  '7306': '梅山',
  '6187': '臺中車站',
  '7005': '民雄站',
};

const Map<String, String> _busRouteTo = {
  '0746': '高鐵嘉義站',
  '7309': '南華大學',
  '7306': '民雄國中',
  '6187': '嘉義市轉運中心',
  '7005': '台北站',
};

List<String> get getBusRoutes => _busRoutes;

String getBusRouteNo(String index) => _busRouteNo[index];

String getBusRouteName(String index) => _busRouteName[index];

String getBusRouteFrom(String index) => _busRouteFrom[index];

String getBusRouteTo(String index) => _busRouteTo[index];

/* ===== Train ===== */

const List<String> _trainStations = [
  '4060',
  '4080',
];

const Map<String, String> _trainStationName = {
  '4060': '民雄',
  '4080': '嘉義',
};

List<String> get getTrainStations => _trainStations;

String getTrainStationName(String index) => _trainStationName[index];

const Map<String, String> _trainName = {
  '1101': '太魯閣', //自強(太，障)
  '1105': '自強(郵)',
  '1104': '自強(專)',
  '1112': '莒光(專)',
  '1120': '復興',
  '1131': '區間', //區間車
  '1132': '區間快',
  '1140': '普快車',
  '1141': '柴快車',
  '1150': '普通車(專)',
  '1151': '普通車',
  '1152': '行包專車',
  '1134': '兩鐵(專)',
  '1270': '普通貨車',
  '1280': '客迴',
  '1281': '柴迴',
  '12A0': '調車列車',
  '12A1': '單機迴送',
  '12B0': '試運轉',
  '4200': '特種(戰)',
  '5230': '特種(警)',
  '1111': '莒光', //莒光(障)
  '1103': '自強', //自強(障)
  '1102': '自強', //自強(腳，障)
  '1100': '自強',
  '1110': '莒光',
  '1121': '復興(專)',
  '1122': '復興(郵)',
  '1113': '莒光(郵)',
  '1282': '臨時客迴',
  '1130': '電車(專)',
  '1133': '電車(郵)',
  '1154': '柴客(專)',
  '1155': '柴客(郵)',
  '1107': '普悠瑪', //自強(普，障)
  '1135': '區間', //區間車(腳，障)
  '1108': '自強', //自強(PP障)
  '1114': '莒光', //莒光(腳)
  '1115': '莒光', //莒光(腳，障)
  '1109': '自強', //自強(PP親)
  '110A': '自強', //自強(PP障12)
  '110B': '自強', //自強(E12)
  '110C': '自強', //自強(E3)
  '110D': '自強', //自強(D28)
  '110E': '自強', //自強(D29)
  '110F': '自強', //自強(D31)
  '1106': '自強(商專)',
};

const Map<String, String> _trainLineName = {
  '0': '不經過山海線',
  '1': '山線',
  '2': '海線',
  '3': '成追',
  '4': '山海',
};

String getTrainName(String index) => _trainName[index];

String getTrainLineName(String index) => _trainLineName[index];

const Set<String> _trainAccessible = {
  '1101',
  '1111',
  '1103',
  '1102',
  '1107',
  '1135',
  '1108',
  '1115',
  '110A',
};

const Set<String> _trainBike = {
  '1102',
  '1135',
  '1114',
  '1115',
};

const Set<String> _trainChild = {
  '1109',
};

bool isTrainAccessible(String index) => _trainAccessible.contains(index);

bool isTrainBike(String index) => _trainBike.contains(index);

bool isTrainChild(String index) => _trainChild.contains(index);
