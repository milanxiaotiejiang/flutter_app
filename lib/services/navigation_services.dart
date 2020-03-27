import 'dart:collection';

import 'package:flutter/services.dart';

const MethodChannel _navigationPlugin =
    MethodChannel('com.milanxiaotiejiang.plugins/navigation');

class Navigation {
  static void openNativePage(String className, {HashMap<String, dynamic> map}) {
    _navigationPlugin.invokeMethod(
        'openNativePage', {'className': className, "params": map});
  }

  static void closeFlutterPage() {
    _navigationPlugin.invokeMethod('closeFlutterPage');
  }
}
