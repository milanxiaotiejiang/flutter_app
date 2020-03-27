import 'package:flutter/material.dart';
import 'package:flutterapp/services/log_services.dart';
import 'dart:async';

import '../plugin/flutter_crash_plugin.dart';

int exceptionCount = 0;

Future<Null> reportError(dynamic error, dynamic stackTrace) async {
  exceptionCount++; //累加异常次数
  Logger.e('Caught error: $error');
  Logger.e('Reporting to Bugly...');
  FlutterCrashPlugin.postException(error, stackTrace);
}

int totalPV = 0;

/// //设置路由监听 navigatorObservers: [ MyObserver(), ], home: HomePage(),

class MyObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    totalPV++; //累加PV
  }
}

double pageException() {
  if (totalPV == 0) return 0;
  return exceptionCount / totalPV;
}
