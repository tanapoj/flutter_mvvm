import 'dart:async';
import 'package:test_mvvm/application/app_lifecycle.dart';
import 'package:test_mvvm/application/app_ui.dart' as ui;

// |=================================================================
// | ViewModel
// |=================================================================

class Test1ViewModel extends ui.ViewModel {
  final LiveData<int> counter;
  final LiveData<String> timer;
  final LiveData<bool> showIfEven;
  final LiveData<String> a;
  final LiveData<int> b;
  final LiveData<bool> c;
  final String name;
  Timer _timer, _timerA, _timerB, _timerC;

  Test1ViewModel(LifeCycleObserver lc, {this.name})
      : counter = LiveData(lc, name: name, initValue: 0),
        timer = LiveData(lc, name: name, initValue: '---'),
        showIfEven = LiveData(lc, name: name, initValue: true),
        a = LiveData(lc, name: name, initValue: '#100'),
        b = LiveData(lc, name: name, initValue: 100),
        c = LiveData(lc, name: name, initValue: false);

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    _timerA.cancel();
    _timerB.cancel();
    _timerC.cancel();
  }

  void incrementCount() {
    print('VM :: count = ${counter.value}');
    counter.value = counter.value + 1;
    showIfEven.value = counter.value % 2 == 0;
  }

  void toggleEven() {
    showIfEven.value = !showIfEven.value;
  }

  void start() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      var now = DateTime.now();
      timer.value = "${now.hour}:${now.minute}:${now.second}";
    });

    _timerA = Timer.periodic(const Duration(milliseconds: 5000), (_) {
      a.value = '#${b.value}';
    });

    _timerB = Timer.periodic(const Duration(milliseconds: 3500), (_) {
      b.value = b.value + 1;
    });

    _timerC = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      c.value = !c.value;
    });
  }
}
