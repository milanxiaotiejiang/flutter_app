import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/pages/error_page.dart';
import 'package:flutterapp/pages/my_home_page.dart';
import 'package:flutterapp/services/log_services.dart';
import 'package:provider/provider.dart';
import 'plugin/flutter_crash_plugin.dart';
import 'util/pv_exception.dart';

Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  reportError(error, stackTrace);
}

/// Flutter 的核心设计思想便是“一切皆 Widget”
/// Flutter 的视图开发是声明式的，其核心设计思想就是将视图和数据分离，这与 React 的设计思路完全一致。
/// 总结来说，命令式编程强调精确控制过程细节；而声明式编程强调通过意图输出结果整体。
Future<Null> main() async {
  //注册Flutter框架的异常回调
  FlutterError.onError = (FlutterErrorDetails details) async {
    //转发至Zone的错误回调
    Zone.current.handleUncaughtError(details.exception, details.stack);
  };
  //自定义错误提示页面
  ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) {
    return ErrorPage();
  };
  //使用runZone方法将runApp的运行放置在Zone中，并提供统一的异常回调
  runZoned<Future<Null>>(() async {
    runApp(MyApp());
    //设置帧回调函数并保存原始帧回调函数
//    orginalCallback = window.onReportTimings;
//    window.onReportTimings = onReportTimings;
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, //设置为透明
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }, onError: (error, stackTrace) async {
    //拦截异常
    await _reportError(error, stackTrace);
  });
}

///当你所要构建的用户界面不随任何状态信息的变化而变化时，需要选择使用 StatelessWidget，反之则选用 StatefulWidget。
class MyApp extends StatefulWidget {
  int startTime;
  int endTime;

  MyApp() {
    startTime = DateTime.now().millisecondsSinceEpoch;
  }

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

///State 的生命周期:创建（插入视图树）、更新（在视图树中存在）、销毁（从视图树中移除）。
class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  //构造方法是 State 生命周期的起点
  _MyAppState();

  //在 State 对象被插入视图树的时候调用
  @override
  void initState() {
    if (Platform.isAndroid) {
      FlutterCrashPlugin.setUp('');
    } else if (Platform.isIOS) {
      FlutterCrashPlugin.setUp('');
    }
    //通过帧绘制回调获取渲染完成时间
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.endTime = DateTime.now().millisecondsSinceEpoch;
      int timeSpend = widget.endTime - widget.startTime;
      Logger.e("Page render time:$timeSpend ms"); //1272
    });
    super.initState();
    WidgetsBinding.instance.addObserver(this); //注册监听器
  }

  //专门处理 State 对象依赖关系变化，会在 initState() 调用结束后，被 Flutter 调用。
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  //构建视图
  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }

  //当状态数据发生变化时
  @override
  void setState(fn) {
    super.setState(fn);
  }

  //当 Widget 的配置发生变化时，比如，父 Widget 触发重建（即父 Widget 的状态发生变化时），热重载时，系统会调用这个函数。
  @override
  void didUpdateWidget(MyApp oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  //当组件的可见状态发生变化时，deactivate 函数会被调用，这时 State 会被暂时从视图树中移除。
  @override
  void deactivate() {
    super.deactivate();
  }

  //当 State 被永久地从视图树中移除时，Flutter 会调用 dispose 函数。
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this); //移除监听器
  }

  //App生命周期变化
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }
}
