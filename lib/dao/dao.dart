import 'package:dio/dio.dart';

class Dao {
  dioDemo() async {
    try {
      Dio dio = new Dio();
      var response = await dio.get("https://flutter.dev",
          options: Options(headers: {"user-agent": "Custom-UA"}));
      print(response.data.toString());
    } catch (e) {
      print('Error:$e');
    }
  }

  dioParallDemo() async {
    try {
      Dio dio = new Dio();
      List<Response> responseX = await Future.wait([
        dio.get("https://flutter.dev"),
        dio.get("https://pub.dev/packages/dio")
      ]);

      //打印请求1响应结果
      print("Response1: ${responseX[0].toString()}");
      //打印请求2响应结果
      print("Response2: ${responseX[1].toString()}");
    } catch (e) {
      print('Error:$e');
    }
  }

  dioInterceptorReject() async {
    Dio dio = new Dio();
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      return dio.reject("Error：拦截的原因");
    }));

    try {
      var response = await dio.get("https://flutter.dev");
      print(response.data.toString());
    } catch (e) {
      print('Error:$e');
    }
  }

  dioIntercepterCache() async {
    Dio dio = new Dio();
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      return dio.resolve("返回缓存数据");
    }));

    try {
      var response = await dio.get("https://flutter.dev");
      print(response.data.toString());
    } catch (e) {
      print('Error:$e');
    }
  }

  dioIntercepterCustomHeader() async {
    Dio dio = new Dio();
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      options.headers["user-agent"] = "Custom-UA";
      return options;
    }));

    try {
      var response = await dio.get("https://flutter.dev");
      print(response.data.toString());
    } catch (e) {
      print('Error:$e');
    }
  }
}
