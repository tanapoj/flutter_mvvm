import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:test_mvvm/application/app_lifecycle.dart';
import 'package:test_mvvm/application/app_ui.dart' as ui;
import 'package:test_mvvm/ui/test2/test2_viewmodel.dart';

class Test2Controller extends ui.Controller {
  final int id;

  Test2Controller([this.id = 1]);

  @override
  ui.View<ui.Controller, ui.ViewModel> getView() => Test2View();
}

class Test2View extends ui.View<Test2Controller, Test2ViewModel> {
  ToggleableSubscriber control;

  Test2View() {
    $viewModel = Test2ViewModel(this);
  }

  @override
  void initState() {
    super.initState();
    control = $viewModel.counter.subscribe((int c) {});
  }

  @override
  Widget buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MVVM ${widget.id}'),
      ),
      body: Center(
        child: buildContent(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      children: <Widget>[
        $watch($viewModel.counter, builder: (int c) {
          return Text('time is $c');
        }),
        Column(
          children: <Widget>[
            $watch($viewModel.loading, builder: (bool loading) {
              if (loading)
                return Text('now Loading');
              else
                return ui.EmptyView();
            }),
            $if(
              $viewModel.loading,
              builder: (_) {
                return Text('now Loading');
              },
              $else: (_) {
                return ui.EmptyView();
              },
            ),
            $switch(
              $viewModel.counter.map((x) => x % 3),
              builders: {
                1: (int count) => Text('A'),
                2: (int count) => Text('B'),
              },
              $default: (int count) => Text('C'),
            ),
            ui.build(() {
              print('');
              return Text('count is ');
            }),
            ui.build(() {
              var combine = LiveData.merge({
                #A: $viewModel.a.stream,
                #B: $viewModel.b.stream,
              });
              return $watch(combine, builder: (pair) {
                Symbol s = pair.first;
                var value = pair.second;
                if (s == #A) {}
                return Text('');
              });
            }),
            ui.build(() {
              var combine = LiveData.zipMemorize({
                #A: $viewModel.a.stream,
                #B: $viewModel.b.stream,
              });
              return $watch(combine, builder: (memorize) {
                var a = memorize[#A];
                var b = memorize[#B];
                return Text('');
              });
            }),
            Text('EVEN NUMBER!'),
            RaisedButton(
              child: Text('toggle EVEN'),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
