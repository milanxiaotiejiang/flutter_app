import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterapp/util/pv_exception.dart';

class NavigatorUtil {
  ///跳转到指定页面
  static push(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
