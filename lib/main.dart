import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'common/ApiFactory/DioFactory.dart';
import 'common/App.dart';
import 'common/Config/Dependencies.dart';
import 'common/Config/Prefs/PrefUtils.dart';
import 'common/Widgets/PBLog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeDefault();

  bool isLoggedIn = await PrefUtils.getIsLoggedIn() ?? false;
  runApp(App(isLoggedIn));
}

Future<void> _initializeDefault() async {
  FirebaseApp app = await Firebase.initializeApp();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  PBLog('Initialized Firebase default app $app');

  // Controller dependencies which we use throughout the app
  Dependencies.injectDependencies();
  DioFactory.initialiseHeaders(await PrefUtils.getToken() ?? "");
}
