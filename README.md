# CCU Toolbox
## Introduction
這是 CCU Toolbox 第 2 版
其架構及 UI 幾乎全部重寫，
改版原因為前版架構維護性太差，
不易新增功能及追蹤更正錯誤。

如果你發現有些舊版功能在新版上消失了，
那是因為我覺得該功能沒必要，
或開發較為耗時，
如果你希望加回來的話，
歡迎發 issue ，
讓我知道有人對這項功能有需求~

### 目前功能
* eCourse2: 公告、作業、成績、檔案
* 課表: 每日、每週
* 交通: 公車、火車
* 行事曆
* 成績查詢

#### Todo
* 新增 token 快取以加快 eCourse2 載入速度
* 點名相關功能

#### In the far far away future (or maybe it never comes)...
* 從課表進入 eCourse2 課程頁面
* Wi-Fi 自動登入
* i18n

## Changelogs

**2.0.2 (2021.06.08)**

**[Fix]** Fix cannot detect invalid token bug

**[Improve]** Some minor improve

**2.0.1 (2021.03.27)**

**[Fix]** Cache moodle token and userid in shared preferences to imporve loading time

**[Fix]** Fix missing holiday mark in schedule data

**2.0.0 (2021.03.15)**

第 2 版: 架構及 UI 全部重寫

## Preparation

### Install Flutter SDK and other tools
Current version (2.0.1) was developed under Flutter SDK 1.22.5

You can download from here:
https://flutter.dev/docs/development/tools/sdk/releases

Please make sure that you have installed the appropriated Flutter SDK version.

And install steps can be found here:
https://flutter.dev/docs/get-started/install

### Add eCourse2 App Token

Change the return value of `getEcourse2AppToken` function in `lib/environments/ecourse2_app_token.dart`

For security reason, if you want to get app token, please contact eCourse2 development team.

### Get dependency

Enter this project directory, then run this command:

`flutter pub get`

## Run on device or emulator
**Debug mode (hot reload enabled)**
`flutter run`

**Profile mode (for performance evaluation)**
`flutter run --profile`

## Build release

### Android
Please refer:
https://flutter.dev/docs/deployment/android

You don't have to do all the pre-build stuff, you only need to:
1. Create a keystore
2. Reference the keystore from the app
3. Change Application Id *(optional) (same appid indicate that it's the same app)*

### iOS
// To be edited...

## Appendix
Old version (1.x):
https://github.com/firecodev/ccu_toolbox
