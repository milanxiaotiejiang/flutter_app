import 'package:dio/dio.dart';
import 'package:flutterapp/services/log_services.dart';

class NetWork {
  static final NetWork _netWork = NetWork._internal();

  factory NetWork() {
    return _netWork;
  }

  NetWork._internal();

  Dio dio;

  static const String API_PREFIX = 'http://www.devio.org/';
  static const int CONNECT_TIMEOUT = 10000;
  static const int RECEIVE_TIMEOUT = 3000;

  /// 创建 dio 实例对象
  Dio createInstance() {
    if (dio == null) {
      /// 全局属性：请求前缀、连接超时时间、响应超时时间
      var options = BaseOptions(
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT,
        responseType: ResponseType.plain,
        validateStatus: (status) {
          // 不使用http状态码判断状态，使用AdapterInterceptor来处理（适用于标准REST风格）
          return true;
        },
        baseUrl: API_PREFIX,
      );

      dio = new Dio(options);

      dio.interceptors
          .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
        Logger.e("NetWork : ${options.toString()}");
      }, onResponse: (Response e) {
        Logger.e("NetWork : ${e.toString()}");
      }, onError: (DioError e) {
        Logger.e("NetWork : ${e.toString()}");
      }));
    }

    return dio;
  }

  /// 清空 dio 对象
  clear() {
    dio = null;
  }
}
