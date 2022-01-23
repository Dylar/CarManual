import 'package:carmanual/core/database.dart';
import 'package:carmanual/datasource/CarInfoDataSource.dart';
import 'package:carmanual/service/car_info_service.dart';
import 'package:flutter/material.dart';

class Services extends InheritedWidget {
  final CarInfoService carInfoService;

  const Services(this.carInfoService, {Key? key, required Widget child})
      : super(key: key, child: child);

  factory Services.init({
    AppDatabase? db,
    CarInfoService? carInfoService,
    Key? key,
    required Widget child,
  }) {
    return Services(
      carInfoService ?? CarInfoService(CarInfoDS(AppDatabase())),
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
