import 'package:carmanual/datasource/CarInfoDataSource.dart';
import 'package:flutter/material.dart';

class Services extends InheritedWidget {
  final CarInfoDataSource? carInfoDataSource;

  const Services({this.carInfoDataSource, Key? key, required Widget child})
      : super(key: key, child: child);

  factory Services.init({
    CarInfoDataSource? carInfoDataSource,
    Key? key,
    required Widget child,
  }) {
    return Services(
      carInfoDataSource: carInfoDataSource,
      key: key,
      child: child,
    );
  }

  static Services? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Services>();
  }

  @override
  bool updateShouldNotify(Services oldWidget) {
    return true;
  }
}
