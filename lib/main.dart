import 'package:flutter/material.dart';
import 'package:test_mvvm/ui/main/imp.dart';
import 'package:test_mvvm/ui/test1/test1_controller.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
//      home: MyHomePage(pageIndex: 1),
      home: Test1Controller(),
    );
  }
}
