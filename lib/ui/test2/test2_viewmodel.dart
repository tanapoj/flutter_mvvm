import 'package:test_mvvm/application/app_lifecycle.dart';
import 'package:test_mvvm/application/app_ui.dart' as ui;

class Test2ViewModel extends ui.ViewModel {
  final LiveData<int> counter;
  final LiveData<bool> loading;
  final LiveData<String> a;
  final LiveData<String> b;

  Test2ViewModel(LifeCycleObserver lc)
      : counter = LiveData(lc, initValue: 1),
        loading = LiveData(lc, initValue: true),
        a = LiveData(lc, initValue: 'a'),
        b = LiveData(lc, initValue: 'b');

  void increment() {
    counter.value = counter.value + 1;
  }
}
