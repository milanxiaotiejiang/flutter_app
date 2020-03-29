import 'package:flutter/material.dart';
import 'package:flutterapp/pages/main/home_page.dart';
import 'package:flutterapp/pages/main/my_page.dart';
import 'file:///E:/zt/project/flutter/flutter_app/flutter_app/lib/pages/search_page.dart';
import 'package:flutterapp/pages/main/travel_page.dart';

class TabNavigator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  int _currentIndex = 0;
  final PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: _controller,
          children: <Widget>[
            TravelPage(),
            HomePage(),
            MyPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            _controller.jumpToPage(index);
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: [
            _bottomItem('首页', Icons.home, 0),
            _bottomItem('旅拍', Icons.camera_alt, 2),
            _bottomItem('我的', Icons.account_circle, 3),
          ],
        ));
  }

  final _defaultColor = Colors.grey;
  final _activeColor = Colors.blue;

  _bottomItem(String title, IconData icon, int index) {
    return BottomNavigationBarItem(
        icon: Icon(
          icon,
          color: _defaultColor,
        ),
        activeIcon: Icon(
          icon,
          color: _activeColor,
        ),
        title: Text(
          title,
          style: TextStyle(
              color: _currentIndex != index ? _defaultColor : _activeColor),
        ));
  }
}
