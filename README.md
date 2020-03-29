# flutterapp

A new Flutter application.

##### 异常处理
  ```
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
  ```
dio
  ```
    final response = await NetWork().dio.get(url);
    if (response.statusCode == 200) {
      var data = response.data;
      var result = json.decode(data);
```
provider
  ```
    return ChangeNotifierProvider.value(
      value: CounterModel(), //需要共享的数据资源
      child: MyHomePage(),
    );
 ```
flutter_splash_screen
 ```
    Future.delayed(Duration(milliseconds: 600), () {
      FlutterSplashScreen.hide();
    });
 ```
flutter_swiper
 ```
      child: Swiper(
        itemCount: bannerList.length,
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          //
        },
        pagination: SwiperPagination(),
      ),
```
flutter_webview_plugin
 ```
              WebView(
                url: item.article.urls[0].h5Url,
                title: '详情',
              ));
 ```
flutter_staggered_grid_view
  ```
              child: StaggeredGridView.countBuilder(
                controller: _scrollController,
                crossAxisCount: 4,
                itemCount: travelItems?.length ?? 0,
                itemBuilder: (BuildContext context, int index) => _TravelItem(
                  index: index,
                  item: travelItems[index],
                ),
                staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
```
underline_indicator
```
              indicator: UnderlineIndicator(
                  strokeCap: StrokeCap.round,
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 3,
                  ),
                  insets: EdgeInsets.only(bottom: 10)),
                  ```
