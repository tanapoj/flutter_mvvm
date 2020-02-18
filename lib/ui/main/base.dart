import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:meta/meta.dart';

abstract class Controller extends StatefulWidget implements LifeCycleObserver {
  final List<LiveData> _liveData = [];

  @override
  State createState() => getView();

  void dispose() {
    _liveData.forEach((liveData) {
      liveData?.dispose();
    });
  }

  @override
  void observeLiveData<T>(LiveData<T> lv) {
    _liveData.add(lv);
  }

  View getView();
}

abstract class ViewModel {}

abstract class LifeCycleObserver {
  void observeLiveData<T>(LiveData<T> lv);
}

class LiveData<T> {
  final T initialValue;
  final StreamController<T> streamController = StreamController<T>.broadcast();
  T _currentValue;

  LiveData(LifeCycleObserver lc, {T initValue})
      : this.initialValue = initValue,
        this._currentValue = initValue {
    lc?.observeLiveData(this);
  }

  set value(T value) {
    this._currentValue = value;
    streamController.add(value);
  }

  T get value => this._currentValue;

  void dispose() {
    streamController.close();
  }

  void listen(
    void onData(T event), {
    Function onError,
    void onDone(),
    bool cancelOnError,
  }) =>
      streamController.stream.listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      );
}

abstract class View<VM extends ViewModel> extends State {
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
        stream: liveData.streamController.stream,
        initialData: liveData.initialValue,
        builder: (BuildContext context, snapshot) {
          var value = snapshot.data;
          assert(value is T);
          return builder(value);
        });
  }

  Widget $ifNot<T extends bool>(
    LiveData<T> liveData, {
    bool Function(T) predicate,
    @required Widget Function(T value) builder,
  }) =>
      $if(liveData, predicate: predicate, builder: builder);

  Widget $if<T extends bool>(
    LiveData<T> liveData, {
    bool Function(T) predicate,
    @required Widget Function(T value) builder,
  }) {
    assert(liveData != null);
    return StreamBuilder(
        stream: liveData.streamController.stream,
        initialData: liveData.initialValue,
        builder: (BuildContext context, snapshot) {
          var value = snapshot.data;
          assert(value is T);
          if (predicate == null && value) {
            return builder(value);
          }
          if (predicate != null && predicate(value)) {
            return builder(value);
          }
          return Container();
        });
  }

  Widget $when<T>(
    LiveData<T> liveData, {
    @required Map<T, Widget Function(T value)> builders,
    Widget Function(T value) $default,
  }) {
    assert(liveData != null);
    return StreamBuilder(
        stream: liveData.streamController.stream,
        initialData: liveData.initialValue,
        builder: (BuildContext context, snapshot) {
          var value = snapshot.data;
          assert(value is T);
          if (builders.containsKey(value)) {
            return builders[value](value);
          } else if ($default != null) {
            return $default(value);
          }
          return Container();
        });
  }
}