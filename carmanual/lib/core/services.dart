import 'package:carmanual/core/database/database.dart';
import 'package:carmanual/core/network/app_client.dart';
import 'package:carmanual/datasource/CarInfoDataSource.dart';
import 'package:carmanual/service/car_info_service.dart';
import 'package:flutter/material.dart';

class Services extends InheritedWidget {
  final AppClient appClient;
  final CarInfoService carInfoService;

  const Services(
    this.appClient,
    this.carInfoService, {
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  factory Services.init({
    AppClient? appClient,
    AppDatabase? db,
    CarInfoService? carInfoService,
    Key? key,
    required Widget child,
  }) {
    return Services(
      appClient ?? AppClient(),
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
