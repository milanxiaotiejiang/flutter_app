import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('错误显示'),
      ),
      body: RaisedButton(
          child: Text('Back'), onPressed: () => Navigator.pop(context)),
    );
  }
}
