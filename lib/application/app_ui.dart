import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:test_mvvm/application/app_log.dart';

import 'app_lifecycle.dart';

abstract class Controller extends StatefulWidget {
  @override
  State createState() => getView();

  View getView();
}

abstract class ViewModel {
  void dispose() {}
}

class EmptyView extends Container {}

abstract class View<C extends Controller, VM extends ViewModel> extends State<C>
    implements LifeCycleObserver {
  final List<LiveData> _liveData = [];
  VM $viewModel;

  @override
  void dispose() {
    super.dispose();
    AppLog.d('{{ui.View}}', 'View.dispose --> dispose all _liveData');
    _liveData.forEach((liveData) {
      AppLog.d('{{ui.View}}', '_liveData.dispose() = $liveData');
      liveData?.dispose();
    });
    $viewModel?.dispose();
  }

  @override
  void observeLiveData<T>(LiveData<T> lv) {
    _liveData.add(lv);
  }

  @override
  Widget build(BuildContext context) {
    return buildScaffold(context);
  }

  Widget buildScaffold(BuildContext context);

  Widget buildContent(BuildContext context);

  Widget $watch<T>(
    LiveData<T> liveData, {
    @required Widget Function(T value) builder,
  }) {
    assert(liveData != null);
    return StreamBuilder(
        stream: liveData.stream,
        initialData: liveData.initialValue,
        builder: (BuildContext context, snapshot) {
          var value = snapshot.data ?? liveData.value ?? liveData.initialValue;
          assert(value is T);
          return builder(value);
        });
  }

  Widget $ifNot<T extends bool>(
    LiveData<T> liveData, {
    bool Function(T) predicate,
    @required Widget Function(T value) builder,
  }) {
    return $if(liveData, predicate: predicate, builder: builder);
  }

  Widget $if<T extends bool>(
    LiveData<T> liveData, {
    bool Function(T) predicate,
    @required Widget Function(T value) builder,
    Widget Function(T value) $else,
  }) {
    assert(liveData != null);
    return StreamBuilder(
        stream: liveData.stream,
        initialData: liveData.initialValue,
        builder: (BuildContext context, snapshot) {
          var value = snapshot.data ?? liveData.value ?? liveData.initialValue;
          assert(value is T);
          if (predicate == null && value) {
            return builder(value);
          }
          if (predicate != null && predicate(value)) {
            return builder(value);
          }
          if ($else != null) {
            return $else(value);
          }
          return EmptyView();
        });
  }

  Widget $switch<T>(
    LiveData<T> liveData, {
    @required Map<T, Widget Function(T value)> builders,
    Widget Function(T value) $default,
  }) {
    assert(liveData != null);
    return StreamBuilder(
        stream: liveData.stream,
        initialData: liveData.initialValue,
        builder: (BuildContext context, snapshot) {
          var value = snapshot.data ?? liveData.value ?? liveData.initialValue;

          if (builders.containsKey(value)) {
            return builders[value](value);
          } else if ($default != null) {
            return $default(value);
          }
          return EmptyView();
        });
  }
}

Widget build(Widget Function() builder) => builder();
