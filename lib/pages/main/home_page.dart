import 'package:flutter/material.dart';
import 'package:flutter_splash_screen/flutter_splash_screen.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutterapp/dao/home_dao.dart';
import 'package:flutterapp/model/common_model.dart';
import 'package:flutterapp/model/grid_nav_model.dart';
import 'package:flutterapp/model/home_model.dart';
import 'package:flutterapp/model/sales_box_model.dart';
import 'package:flutterapp/pages/main/search_page.dart';
import 'package:flutterapp/services/log_services.dart';
import 'package:flutterapp/util/navigator_util.dart';
import 'package:flutterapp/widget/grid_nav.dart';
import 'package:flutterapp/widget/loading_container.dart';
import 'package:flutterapp/widget/local_nav.dart';
import 'package:flutterapp/widget/sales_box.dart';
import 'package:flutterapp/widget/search_bar.dart';
import 'package:flutterapp/widget/sub_nav.dart';
import 'package:flutterapp/widget/webview.dart';

const APPBAR_SCROLL_OFFSET = 100;
const SEARCH_BAR_DEFAULT_TEXT = '网红打卡地 景点 酒店 美食';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double appBarAlpha = 0;
  List<CommonModel> localNavList = [];
  List<CommonModel> bannerList = [];
  List<CommonModel> subNavList = [];
  GridNavModel gridNavModel;
  SalesBoxModel salesBoxModel;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _handleRefresh();
    Future.delayed(Duration(milliseconds: 600), () {
      FlutterSplashScreen.hide();
    });
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
      backgroundColor: Color(0xfff2f2f2),
      body: LoadingContainer(
          isLoading: _loading,
          child: Stack(
            children: <Widget>[
              //建立媒体查询解析给定数据的子树
              //例如，要了解当前媒体的大小（例如，包含您的应用程序的窗口），您可以从MediaQuery.of返回的MediaQueryData中读取
              MediaQuery.removePadding(
                removeTop: true,
                context: context,
                /**
                 * 下拉刷新组件
                 *const RefreshIndicator
                    ({
                    Key key,
                    @required this.child,
                    this.displacement: 40.0, //触发下拉刷新的距离
                    @required this.onRefresh, //下拉回调方法,方法需要有async和await关键字，没有await，刷新图标立马消失，没有async，刷新图标不会消失
                    this.color, //进度指示器前景色 默认为系统主题色
                    this.backgroundColor, //背景色
                    this.notificationPredicate: defaultScrollNotificationPredicate,
                    })
                 */
                child: RefreshIndicator(
                    onRefresh: _handleRefresh,
                    /**
                     * const NotificationListener({
                        Key key,
                        @required this.child,  被监控的子widget树
                        this.onNotification,  监控到notification后的回调方法。
                        })
                     */
                    child: NotificationListener(
                      onNotification: (scrollNotification) {
                        if (scrollNotification is ScrollUpdateNotification &&
                            scrollNotification.depth == 0) {
                          //滚动且是列表滚动的时候
                          _onScroll(scrollNotification.metrics.pixels);
                        }
                      },
                      child: _listView,
                    )),
              ),
              _appBar
            ],
          )),
    );
  }

  Future<Null> _handleRefresh() async {
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        localNavList = model.localNavList;
        subNavList = model.subNavList;
        gridNavModel = model.gridNav;
        salesBoxModel = model.salesBox;
        bannerList = model.bannerList;
        _loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
      });
    }
    return null;
  }

  void _onScroll(double offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
    print(appBarAlpha);
  }

  Widget get _listView {
    return ListView(
      children: <Widget>[
        _banner,
        /**
         * 设置内边距
         */
        Padding(
          /**
           * fromLTRB(double left, double top, double right, double bottom)：分别指定四个方向的填充。
              all(double value) : 所有方向均使用相同数值的填充。
              only({left, top, right ,bottom })：可以设置具体某个方向的填充(可以同时指定多个方向)。
              symmetric({vertical, horizontal})：用于设置对称方向的填充，vertical指top和bottom，horizontal指left和right。
           */
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: LocalNav(localNavList: localNavList),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
            child: GridNav(gridNavModel: gridNavModel)),
        Padding(
            padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
            child: SubNav(subNavList: subNavList)),
        Padding(
            padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
            child: SalesBox(salesBox: salesBoxModel)),
      ],
    );
  }

  Widget get _appBar {
    /**
     * column主轴方向是垂直的方向
     */
    return Column(
      children: <Widget>[
        /**
         * 是一个结合了绘制（painting）、定位（positioning）以及尺寸（sizing）widget的widget。
         */
        Container(
          /**
           * 提供了多种绘制盒子的方法。
           */
          decoration: BoxDecoration(
            //渐变
            gradient: LinearGradient(
              //AppBar渐变遮罩背景
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Container(
            /**
             * fromLTRB(double left, double top, double right, double bottom)：分别指定四个方向的填充。
                all(double value) : 所有方向均使用相同数值的填充。
                only({left, top, right ,bottom })：可以设置具体某个方向的填充(可以同时指定多个方向)。
                symmetric({vertical, horizontal})：用于设置对称方向的填充，vertical指top和bottom，horizontal指left和right。
             */
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 80.0,
            decoration: BoxDecoration(
              color: Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255),
            ),
            child: SearchBar(
              searchBarType: appBarAlpha > 0.2
                  ? SearchBarType.homeLight
                  : SearchBarType.home,
              inputBoxClick: _jumpToSearch,
              speakClick: _jumpToSpeak,
              defaultText: SEARCH_BAR_DEFAULT_TEXT,
              leftButtonClick: () {
                Logger.e("leftButtonClick");
              },
            ),
          ),
        ),
        Container(height: appBarAlpha > 0.2 ? 0.5 : 0, decoration: BoxDecoration(
            /** 阴影效果
              const BoxShadow({
              Color color = const Color(0xFF000000),//阴影默认颜色,不能与父容器同时设置color
              Offset offset = Offset.zero,//延伸的阴影，向右下偏移的距离
              double blurRadius = 0.0,//延伸距离,会有模糊效果
              this.spreadRadius = 0.0 //延伸距离,不会有模糊效果
              })
           */
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)]))
      ],
    );
  }

  Widget get _banner {
    return Container(
      height: 160,
      child: Swiper(
        itemCount: bannerList.length,
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              CommonModel model = bannerList[index];
              NavigatorUtil.push(
                  context,
                  WebView(
                      url: model.url,
                      title: model.title,
                      hideAppBar: model.hideAppBar));
            },
            child: Image.network(
              bannerList[index].icon,
              fit: BoxFit.fill,
            ),
          );
        },
        pagination: SwiperPagination(),
      ),
    );
  }

  _jumpToSearch() {
    NavigatorUtil.push(
        context,
        SearchPage(
          hint: SEARCH_BAR_DEFAULT_TEXT,
        ));
  }

  _jumpToSpeak() {
//    NavigatorUtil.push(context, SpeakPage());
  }
}
