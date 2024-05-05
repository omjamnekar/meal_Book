import 'package:flutter/material.dart';

class AsyncDataChecker {
  Widget checkWidgetBinding(
      {required Widget widget,
      required Widget loadingWidget,
      required AsyncSnapshot<dynamic> snapshot,
      required dynamic Function() afterBindingFunction}) {
    if (snapshot.connectionState == ConnectionState.waiting &&
        !snapshot.hasData) {
      return loadingWidget;
    } else if (snapshot.connectionState == ConnectionState.active &&
        !snapshot.hasData) {
      return loadingWidget;
    } else if (snapshot.connectionState == ConnectionState.done &&
        snapshot.hasData) {
      afterBindingFunction.call();
      return widget;
    } else if (snapshot.connectionState == ConnectionState.done &&
        !snapshot.hasData) {
      return loadingWidget;
    }
    return loadingWidget;
  }
}
