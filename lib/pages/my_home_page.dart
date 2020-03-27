import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/app_theme.dart';
import 'package:flutterapp/dao/net_work.dart';
import 'package:flutterapp/navigator/tab_navigator.dart';
import 'package:flutterapp/pages/unknown_page.dart';
import 'package:flutterapp/util/pv_exception.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NetWork().createInstance();
    return MaterialApp(
      title: 'Flutter',
      //标题
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kAndroidTheme,
      //注册路由
      //使用名字打开页面 Navigator.pushNamed(context,"second_page");
      routes: {
//        "second_page": (context) => SecondPage(),
      },
      //路由异常页面
      onUnknownRoute: (RouteSettings setting) =>
          MaterialPageRoute(builder: (context) => UnknownPage()),
      home: TabNavigator(),
      navigatorObservers: [
        MyObserver(),
      ],
    );
  }
}
