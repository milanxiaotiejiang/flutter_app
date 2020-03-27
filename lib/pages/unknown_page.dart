import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UnknownPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('未找到此页面'),
      ),
      body: RaisedButton(
          child: Text('Back'), onPressed: () => Navigator.pop(context)),
    );
  }
}
