//import 'dart:async';
//
//import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
//import 'package:test_mvvm/application/app_lifecycle.dart';
//import 'package:test_mvvm/application/app_ui.dart';
//
//// |=================================================================
//// | Controller
//// |=================================================================
//// ignore: must_be_immutable
//class Controller1 extends Controller {
//  ViewModel1 viewModel1;
//
//  Controller1() {
//    viewModel1 = ViewModel1(this);
//  }
//
//  @override
//  View<ViewModel> getView() => View1(viewModel1);
//}
//
//// |=================================================================
//// | View
//// |=================================================================
//
//class View1 extends View {
//  final ViewModel1 $viewModel;
//
//  View1(ViewModel1 viewModel) : $viewModel = viewModel;
//
//  @override
//  void initState() {
//    super.initState();
//    print('View :: --- initState');
//    $viewModel.start();
//    $viewModel.counter.subscribe((int count){
//      print('LISTEN count = $count');
//    });
//  }
//
//  @override
//  void dispose() {
//    super.dispose();
//    print('View :: --- dispose');
//  }
//
//  @override
//  Widget buildScaffold(BuildContext context) {
//    print('View :: buildScaffold');
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('MVVM'),
//      ),
//      body: Center(
//        child: buildContent(context),
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          print('+1');
//          $viewModel.incrementCount();
//        },
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ),
//    );
//  }
//
//  @override
//  Widget buildContent(BuildContext context) {
//    print('View :: buildContent');
////    var x = Column(
////      children: <Widget>[
////        Text('time is \$time'),
////        Column(
////          children: <Widget>[
////            Text('count is \$count'),
////            Text('EVEN NUMBER!'),
////            RaisedButton(
////              child: Text('toggle EVEN'),
////              onPressed: () {
////                print('EVEN');
////                $viewModel.toggleEven();
////              },
////            ),
////          ],
////        ),
////      ],
////    );
//    return Column(
//      children: <Widget>[
//        $watch($viewModel.timer, builder: (String time) {
//          print('');
//          print('View :: ------------------------------------- \$watch timer');
//          print('');
//          return Text('time is $time');
//        }),
//        $watch($viewModel.counter, builder: (int count) {
//          print('View :: \$watch counter');
//          return Column(
//            children: <Widget>[
//              Text('count is $count'),
//              $if($viewModel.showIfEven, builder: (_) {
//                print('View :: \$if showIfEven');
//                return Text('EVEN NUMBER!');
//              }),
//              $when(
//                $viewModel.counter,
//                builders: {
//                  1: (int count) => Text('One $count'),
//                  2: (int count) => Text('Two $count'),
//                },
//                $default: (int count) => Text('More Than Two $count'),
//              ),
//            ],
//          );
//        }),
//        RaisedButton(
//          child: Text('toggle EVEN'),
//          onPressed: () {
//            print('EVEN');
//            $viewModel.toggleEven();
//          },
//        ),
//      ],
//    );
//  }
//}
//
//// |=================================================================
//// | ViewModel
//// |=================================================================
//
//class ViewModel1 extends ViewModel {
//  final LiveData<int> counter;
//  final LiveData<String> timer;
//  final LiveData<bool> showIfEven;
//
//  ViewModel1(LifeCycleObserver lc)
//      : counter = LiveData(lc, initValue: 0),
//        timer = LiveData(lc, initValue: '---'),
//        showIfEven = LiveData(lc, initValue: true);
//
//  void incrementCount() {
//    print('VM :: count = ${counter.value}');
//    counter.value = counter.value + 1;
//    showIfEven.value = counter.value % 2 == 0;
//  }
//
//  void toggleEven() {
//    showIfEven.value = !showIfEven.value;
//  }
//
//  void start() {
//    Timer.periodic(const Duration(seconds: 5), (_) {
//      var now = DateTime.now();
//      timer.value = "${now.hour}:${now.minute}:${now.second}";
//    });
//  }
//}
