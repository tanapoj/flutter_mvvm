import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test_mvvm/application/app_lifecycle.dart';
import 'package:test_mvvm/application/app_log.dart';
import 'package:test_mvvm/application/app_ui.dart' as ui;
import 'package:test_mvvm/application/fp.dart';
import 'package:test_mvvm/ui/test1/test1_viewmodel.dart';

class Route {
  final String name;

  const Route({this.name});
}

// |=================================================================
// | Controller
// |=================================================================

@Route(name: '/test')
class Test1Controller extends ui.Controller {
  final int id;

  Test1Controller([this.id = 1]);

  @override
  ui.View<Test1Controller, Test1ViewModel> getView() => Test1View(id);
}

// |=================================================================
// | View
// |=================================================================

class Test1View extends ui.View<Test1Controller, Test1ViewModel> {
  bool controlToggle = true;
  ToggleableSubscriber control;

  Test1View(int id) {
    $viewModel = Test1ViewModel(this, name: 'VM-$id');
  }

  String get tag => 'V-${widget.id}';

  @override
  void initState() {
    super.initState();
    AppLog.d(tag, 'View :: --- initState');
    $viewModel.start();
    control = $viewModel.counter.subscribe((int count) {
      AppLog.d(tag, 'LISTEN count = $count');
    });
  }

  @override
  void dispose() {
    super.dispose();
    AppLog.d(tag, 'View :: --- dispose');
  }

  @override
  Widget buildScaffold(BuildContext context) {
    AppLog.d(tag, 'View :: buildScaffold');
    return Scaffold(
      appBar: AppBar(
        title: Text('MVVM ${widget.id}'),
      ),
      body: Center(
        child: buildContent(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppLog.d(tag, 'click +1');
          $viewModel.incrementCount();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    AppLog.d(tag, 'View :: buildContent');
//    var x = Column(
//      children: <Widget>[
//        Text('time is \$time'),
//        Column(
//          children: <Widget>[
//            Text('count is \$count'),
//            Text('EVEN NUMBER!'),
//            RaisedButton(
//              child: Text('toggle EVEN'),
//              onPressed: () {
//                print('EVEN');
//                $viewModel.toggleEven();
//              },
//            ),
//          ],
//        ),
//      ],
//    );

    return Column(
      children: <Widget>[
        $watch($viewModel.timer, builder: (String time) {
          //AppLog.d(tag, 'View :: ------------------------------------- \$watch timer');
          return Text('time is $time');
        }),
        $watch($viewModel.counter, builder: (int count) {
          AppLog.d(tag, 'View :: \$watch counter');
          return Column(
            children: <Widget>[
              Text('count is $count'),
              $if(
                $viewModel.showIfEven,
                builder: (_) {
                  AppLog.d(tag, 'View :: \$if showIfEven $_');
                  return Text('EVEN NUMBER!');
                },
                $else: (_) {
                  AppLog.d(tag, 'View :: \$if showIfEven $_');
                  return Text('ODD  NUMBER!');
                },
              ),
              $switch(
                $viewModel.counter.map((n) => n % 4),
                builders: {
                  1: (int count) => Text('One $count'),
                  2: (int count) => Text('Two $count'),
                },
                $default: (int count) => Text('Modulo to $count'),
              ),
              $switch(
                $viewModel.counter,
                builders: {
                  1: (int count) => Text('One $count'),
                  2: (int count) => Text('Two $count'),
                },
                $default: (int count) => Text('More Than Two $count'),
              ),
            ],
          );
        }),
        RaisedButton(
          child: Text('toggle EVEN'),
          onPressed: () {
            AppLog.d(tag, 'click EVEN');
            $viewModel.toggleEven();
          },
        ),
        RaisedButton(
          child: Text('NEXT PAGE'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Test1Controller(widget.id + 1)),
            );
          },
        ),
        RaisedButton(
          child: Text('COUNTER Control $controlToggle'),
          onPressed: () {
            setState(() {
              controlToggle = !controlToggle;
            });
            //print('controlToggle $controlToggle');
            if (controlToggle) {
              control.pause();
            } else {
              control.resume();
            }
          },
        ),
        $watch($viewModel.a, builder: (String a) {
          return Text('{{ $a }}');
        }),
        $watch($viewModel.b, builder: (int b) {
          return Text('{{ $b }}');
        }),
        $watch($viewModel.c, builder: (bool c) {
          return Text('{{ $c }}');
        }),
        ui.build(() {
          try {
            var combine = LiveData.zipMemorize({
              #A: $viewModel.a.stream,
              #B: $viewModel.b.stream,
              #C: $viewModel.c.stream,
            });
            return $watch(combine, builder: (memorize) {
              var data = Memorize.from(memorize);
              return Text('{{ ${data[#A]} / ${data[#B]} / ${data[#C]} }}');
            });
          } catch (e) {
            AppLog.d(tag, '$e');
            return ui.EmptyView();
          }
        }),
        ui.build(() {
          try {
            var combine = LiveData.merge({
              #A: $viewModel.a.stream,
              #B: $viewModel.b.stream,
              #C: $viewModel.c.stream,
            });
            return $watch(combine, builder: (pair) {
              Symbol s = pair?.first as Symbol ?? #None;
              var v = pair?.second ?? null;
              return Text('{{ $s = $v }}');
            });
          } catch (e) {
            AppLog.d(tag, '$e');
            return ui.EmptyView();
          }
        }),
      ],
    );
  }
}
