import 'dart:convert';

import 'package:flutterapp/model/home_model.dart';

import 'net_work.dart';

const HOME_URL = 'http://www.devio.org/io/flutter_app/json/home_page.json';

///首页大接口
class HomeDao {
  static Future<HomeModel> fetch() async {
    final response = await NetWork().dio.get(HOME_URL);
    if (response.statusCode == 200) {
      var data = response.data;
      var result = json.decode(data);
      return HomeModel.fromJson(result);
    } else {
      throw Exception('Failed to load home_page.json');
    }
  }
}
