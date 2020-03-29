import 'dart:async';
import 'dart:convert';

import 'package:flutterapp/model/seach_model.dart';

import 'net_work.dart';

///搜索接口
class SearchDao {
  static Future<SearchModel> fetch(String url, String text) async {
    final response = await NetWork().dio.get(url);
    if (response.statusCode == 200) {
      var data = response.data;
      var result = json.decode(data);
      //只有当当前输入的内容和服务端返回的内容一致时才渲染
      SearchModel model = SearchModel.fromJson(result);
      model.keyword = text;
      return model;
    } else {
      throw Exception('Failed to load home_page.json');
    }
  }
}
