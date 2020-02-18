import 'package:flutter/widgets.dart';
import 'package:mvvm/mvvm.dart';
import 'dart:async';
import 'package:meta/meta.dart';


class MainViewModel extends ViewModel {
  MainViewModel() {
    propertyValue<String>(#time, initial: "");
    propertyValue<int>(#counter, initial: 0);
    start();
  }

  start() {
    Timer.periodic(const Duration(seconds: 1), (_) {
      var now = DateTime.now();
      setValue<String>(#time, "${now.hour}:${now.minute}:${now.second}");
    });
  }

  inc() {
    setValue(#counter, getValue(#counter) + 1);
  }
}
