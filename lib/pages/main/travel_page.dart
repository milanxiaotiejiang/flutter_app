import 'package:flutter/material.dart';
import 'package:flutterapp/dao/travel_tab_dao.dart';
import 'package:flutterapp/model/travel_tab_model.dart';
import 'package:flutterapp/services/log_services.dart';
import 'package:underline_indicator/underline_indicator.dart';

import '../travel_tab_page.dart';

class TravelPage extends StatefulWidget {
  @override
  _TravelPageState createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> with TickerProviderStateMixin {
  TabController _controller;
  List<TravelTab> tabs = [];
  TravelTabModel travelTabModel;

  @override
  void initState() {
    /**
     * 页面必须继承StatefulWidget
        页面必须实现SingleTickerProviderStateMixin
        页面初始化时，实例化TabController
        在TabBar组件中指定controller为我们实例化的TabController
        在TabBarView组件中指定controller为我们实例化的TabController
     */
    _controller = TabController(length: 0, vsync: this);
    TravelTabDao.fetch().then((TravelTabModel model) {
      _controller = TabController(
          length: model.tabs.length, vsync: this); //fix tab label 空白问题
      setState(() {
        tabs = model.tabs;
        travelTabModel = model;
      });
    }).catchError((e) {
      Logger.e(e);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /**
     * const Scaffold({
        Key key,
        this.appBar, // 标题栏
        this.body,  // 用于显示当前界面主要内容的Widget
        this.floatingActionButton, // 一个悬浮在body上的按钮，默认显示在右下角
        this.floatingActionButtonLocation, // 用于设置floatingActionButton显示的位置
        this.floatingActionButtonAnimator, // floatingActionButton移动到一个新的位置时的动画
        this.persistentFooterButtons, // 多状态按钮
        this.drawer, // 左侧的抽屉菜单
        this.endDrawer, //  右'侧的抽屉菜单
        this.bottomNavigationBar,// 底部导航栏。
        this.bottomSheet, // 显示在底部的工具栏
        this.backgroundColor,// 内容的背景颜色
        this.resizeToAvoidBottomPadding = true, // 控制界面内容 body 是否重新布局来避免底部被覆盖，比如当键盘显示的时候，重新布局避免被键盘盖住内容。
        this.primary = true,// Scaffold是否显示在页面的顶部
        })
     */
    return Scaffold(

        ///垂直的方向
        body: Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 30),
          /**
                  const TabBar({
                  Key key,
                  @required this.tabs,//显示的标签内容，一般使用Tab对象,也可以是其他的Widget
                  this.controller,//TabController对象
                  this.isScrollable = false,//是否可滚动
                  this.indicatorColor,//指示器颜色
                  this.indicatorWeight = 2.0,//指示器高度
                  this.indicatorPadding = EdgeInsets.zero,//底部指示器的Padding
                  this.indicator,//指示器decoration，例如边框等
                  this.indicatorSize,//指示器大小计算方式，TabBarIndicatorSize.label跟文字等宽,TabBarIndicatorSize.tab跟每个tab等宽
                  this.labelColor,//选中label颜色
                  this.labelStyle,//选中label的Style
                  this.labelPadding,//每个label的padding值
                  this.unselectedLabelColor,//未选中label颜色
                  this.unselectedLabelStyle,//未选中label的Style
                  }) : assert(tabs != null),
                  assert(isScrollable != null),
                  assert(indicator != null || (indicatorWeight != null && indicatorWeight > 0.0)),
                  assert(indicator != null || (indicatorPadding != null)),
                  super(key: key);
               */
          /**
           * isScrollable	bool	是否可以水平移动
              tabs	List<Widget>	Tab选项列表
           */
          child: TabBar(
              controller: _controller,
              isScrollable: true,
              labelColor: Colors.black,
              labelPadding: EdgeInsets.fromLTRB(20, 0, 10, 5),
              indicator: UnderlineIndicator(
                  strokeCap: StrokeCap.round,
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 3,
                  ),
                  insets: EdgeInsets.only(bottom: 10)),
              tabs: tabs.map<Tab>((TravelTab tab) {
                /**
                 * icon	Widget	Tab图标
                    text	String	Tab文本
                 */
                return Tab(
                  text: tab.labelName,
                );
              }).toList()),
        ),
        /**
         * Flexible是一个控制Row、Column、Flex等子组件如何布局的组件。
         * Flexible组件可以使Row、Column、Flex等子组件在主轴方向有填充可用空间的能力
         * (例如，Row在水平方向，Column在垂直方向)，但是它与Expanded组件不同，它不强制子组件填充可用空间。
         */
        Flexible(
          /**
           * controller	TabController	指定视图的控制器
              children	List<Widget>	视图组件的child为一个列表，一个选项卡对应一个视图
           */
            child: TabBarView(
                controller: _controller,
                children: tabs.map((TravelTab tab) {
                  return TravelTabPage(
                    travelUrl: travelTabModel.url,
                    params: travelTabModel.params,
                    groupChannelCode: tab.groupChannelCode,
                  );
                }).toList()))
      ],
    ));
  }
}
