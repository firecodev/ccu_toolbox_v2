String get getUserAgent => 'Dart/2.10 (dart:io)';

const Map<String, String> _urls = {
  'base':
      'https://kiki.ccu.edu.tw/~ccmisp06/cgi-bin/', // Be aware, this url should end with '/'
  'login': 'class_new/bookmark.php',
  'getCourses': 'class_new/Selected_View00.cgi',
  'grade': 'Query/Query_grade.php',
};

String getKikiUrl(String index) => _urls[index];

const Map<String, int> _startTime = {
  '1': 430,
  'A': 435,
  '2': 490,
  'B': 525,
  '3': 550,
  '4': 610,
  'C': 615,
  '5': 670,
  'D': 705,
  '6': 730,
  '7': 790,
  'E': 795,
  '8': 850,
  'F': 885,
  '9': 910,
  '10': 970,
  'G': 975,
  '11': 1030,
  'H': 1065,
  '12': 1090,
  '13': 1150,
  'I': 1155,
  '14': 1210,
  'J': 1245,
  '15': 1270,
};

const Map<String, int> _endTime = {
  '1': 480,
  'A': 510,
  '2': 540,
  'B': 600,
  '3': 600,
  '4': 660,
  'C': 690,
  '5': 720,
  'D': 780,
  '6': 780,
  '7': 840,
  'E': 870,
  '8': 900,
  'F': 960,
  '9': 960,
  '10': 1020,
  'G': 1050,
  '11': 1080,
  'H': 1140,
  '12': 1140,
  '13': 1200,
  'I': 1230,
  '14': 1260,
  'J': 1320,
  '15': 1320,
};

int getStartTime(String index) => _startTime[index];

int getEndTime(String index) => _endTime[index];

const Map<String, int> _weekday = {
  '一': 1,
  '二': 2,
  '三': 3,
  '四': 4,
  '五': 5,
  '六': 6,
  '日': 7,
};

int getWeekday(String index) => _weekday[index];
