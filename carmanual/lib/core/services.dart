import 'package:carmanual/core/database.dart';
import 'package:carmanual/datasource/CarInfoDataSource.dart';
import 'package:carmanual/service/car_info_service.dart';
import 'package:flutter/material.dart';

class Services extends InheritedWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final CarInfoService carInfoService;

  const Services(this.navigatorKey, this.carInfoService,
      {Key? key, required Widget child})
      : super(key: key, child: child);

  factory Services.init({
    AppDatabase? db,
    CarInfoService? carInfoService,
    Key? key,
    required Widget child,
    required GlobalKey<NavigatorState> navigatorKey,
  }) {
    return Services(
      navigatorKey,
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
