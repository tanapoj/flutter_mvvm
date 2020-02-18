import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mvvm/mvvm.dart';
import 'src_viewmodel.dart';

class MainView extends View<MainViewModel> {
  MainView() : super(MainViewModel());

  @override
  Widget build(BuildContext context) {
    return wrapper();
  }

  Widget wrapper() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test MVVM'),
      ),
      body: body(),
      floatingActionButton: floatingActionButton(),
    );
  }

  Widget body() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: contentList(),
      ),
    );
  }

  List<Widget> contentList() {
    return <Widget>[
      time(),
      counter(),
    ];
  }

  Widget time() {
    return $.watchFor<String>(
      #time,
      builder: $.builder1(
        (t) => Text(t, textDirection: TextDirection.ltr),
      ),
    );
  }

  Widget counter() {
    return $.watchFor<String>(
      #time,
      builder: $.builder1(
        (t) => Text(t, textDirection: TextDirection.ltr),
      ),
    );
  }

  Widget floatingActionButton() {
    return FloatingActionButton(
      onPressed: $Model.inc(),
      tooltip: 'Increment',
      child: Icon(Icons.add),
    );
  }
}
