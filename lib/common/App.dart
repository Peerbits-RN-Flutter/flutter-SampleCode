import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:Common/common/ApiFactory/Modules/AuthenticationAPI.dart';
import 'package:Common/src/Home/Views/HomeView.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'ApiFactory/DioFactory.dart';
import 'Config/AppFont.dart';
import 'Config/Config.dart';
import 'Config/Localization/Translations.dart';
import 'Widgets/PBLog.dart';

class App extends StatefulWidget {
  final bool isLoggedIn;

  App(this.isLoggedIn);

  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

class _AppState extends State<App> {
  var _initStateFlag = false;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    if (!kReleaseMode) {
      log('initState', name: '_AppState::initState');
    }
    _initStateFlag = true;

    // FirebaseMessaging.instance.requestPermission();
    //Local notification code when app in foreground
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_initStateFlag) {
      _initStateFlag = false;
      await DioFactory.computeDeviceInfo();
      Config.FCM_TOKEN = await FirebaseMessaging.instance.getToken() ?? "";
      PBLog("FCM_TOKEN  ${Config.FCM_TOKEN}");
      FirebaseMessaging.instance.onTokenRefresh.listen((event) {
        Config.FCM_TOKEN = event;
        DioFactory.initFCMToken(Config.FCM_TOKEN);
      });
      getToken(token: Config.FCM_TOKEN);
      handleNotification();
    }
  }

  handleNotification() {
    FirebaseMessaging.onMessage.listen((event) {
      PBLog("onMessage: ${event.notification?.body}");
      showNotification(event);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      PBLog("onMessageOpenedApp: ${event.notification?.body}");
      navigate(event.data);
    });
  }

  Future<void> onSelectNotification(payload) async {
    var data = jsonDecode(payload);
    navigate(data);
  }

  void showNotification(RemoteMessage message) async {
    await _demoNotification(message);
  }

  Future<void> _demoNotification(RemoteMessage message) async {
    String? _title = message.notification?.title;
    String? _body = message.notification?.body;
    // if (Platform.isIOS) {
    //   _title = message["aps"]["alert"]["title"];

    //   _body = message["aps"]["alert"]["body"];
    // } else {
    //   _title = message["data"]["title"];
    //   _body = message["data"]["body"];
    // }
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_ID',
      'channel name',
      'channel description',
      importance: Importance.max,
      playSound: true,
      showProgress: true,
      priority: Priority.high,
      ticker: 'test ticker',
    );
    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      _title,
      _body,
      platformChannelSpecifics,
      payload: jsonEncode(message.data),
    );
  }

  navigate(Map<String, dynamic> message) {
    PBLog("_navigate method $message");
    String notifType = "";
    if (Platform.isIOS) {
      notifType = message["notification_type"] ?? "";
    } else {
      notifType = message["data"]["notification_type"] ?? "";
    }

    /*if (notifType != null && notifType != "") {
    switch (notifType.initNotification) {
      case Enum_Notification.received_proposal:
        Get.offAll(BottomTabs(2));
        PBLog("received_proposal");
        break;
      case Enum_Notification.chat:
        Get.offAll(BottomTabs(3));
        PBLog("chat");
        break;
      default:
        Get.to(NotificationsView());
        break;
    }
  }*/
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // builder: DevicePreview.appBuilder,
      translations: AppTranslations(),
      locale: Get.deviceLocale,
      fallbackLocale: Locale('en', 'US'),
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.light,
        fontFamily: AppFont.Roboto_Regular,
      ),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Common',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: Config.supportedLocales,
      // home: widget.isLoggedIn ? BottomTabs(0) : Tutorials(),
      home: MyHomePage(
        title: "Home",
      ),
    );
  }
}
