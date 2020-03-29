import 'dart:async';
import 'dart:convert';

import 'package:flutterapp/model/travel_tab_model.dart';

import 'net_work.dart';

///旅拍类别接口
class TravelTabDao {
  static Future<TravelTabModel> fetch() async {
    final response = await NetWork()
        .dio
        .get('http://www.devio.org/io/flutter_app/json/travel_page.json');
    if (response.statusCode == 200) {

      var result = json.decode(response.data);
      return TravelTabModel.fromJson(result);
    } else {
      throw Exception('Failed to load travel_page.json');
    }
  }
}
