import 'dart:convert';

import 'package:carmanual/datasource/CarInfoDataSource.dart';
import 'package:carmanual/models/car_info.dart';

class CarInfoService {
  CarInfoService(this.carInfoDataSource);

  CarInfoDataSource carInfoDataSource;

  Future<void> onNewScan(String scan) async {
    Map<String, dynamic> infoMap = jsonDecode(scan);
    final carInfo = CarInfo.fromJson(infoMap);
    carInfoDataSource.addCarInfo(carInfo);
  }
}
