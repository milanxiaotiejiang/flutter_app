import 'package:flutter/services.dart';

//声明MethodChannel
const _platform = const MethodChannel('com.milanxiaotiejiang.plugins/log');

class Logger {
  Logger._();

  //invokeMethod方法接收的参数，第一个必选参数，设置的是方法的名称；后面的参数为可选的需要传递的参数

  static void i(String msg) async {
    _platform.invokeMethod('logI', {'msg': msg});
  }

  static void d(String msg) async {
    _platform.invokeMethod('logD', {'msg': msg});
  }

  static void v(String msg) async {
    _platform.invokeMethod('logV', {'msg': msg});
  }

  static void w(String msg) async {
    _platform.invokeMethod('logW', {'msg': msg});
  }

  static void e(String msg) async {
    _platform.invokeMethod('logE', {'msg': msg});
  }
}
