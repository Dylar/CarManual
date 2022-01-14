import 'package:carmanual/datasource/CarInfoDataSource.dart';
import 'package:flutter/material.dart';

class Services extends InheritedWidget {
  final CarInfoDataSource notesDataSource;

  const Services({this.notesDataSource, Key key, Widget child})
      : super(key: key, child: child);

  factory Services.init({
    CarInfoDataSource carInfoDataSource,
    Key key,
    Widget child,
  }) {
    return Services(
      notesDataSource: carInfoDataSource,
      key: key,
      child: child,
    );
  }

  static Services of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Services>();
  }

  @override
  bool updateShouldNotify(Services oldWidget) {
    return true;
  }
}
