import 'dart:convert';

import 'package:carmanual/core/datasource/CarInfoDataSource.dart';
import 'package:carmanual/core/helper/tuple.dart';
import 'package:carmanual/models/car_info.dart';

enum QrScanState { NEW, OLD, DAFUQ, WAITING }

class CarInfoService {
  CarInfoService(this.carInfoDataSource);

  CarInfoDataSource carInfoDataSource; //TODO private

  Future<Tuple<QrScanState, CarInfo>> onNewScan(String scan) async {
    print("Logging: scan: $scan");
    try {
      Map<String, dynamic> infoMap = jsonDecode(scan);
      final carInfo = CarInfo.fromMap(infoMap);
      final isOldCar = await _isOldCar(carInfo);
      if (isOldCar) {
        return Tuple(QrScanState.OLD, carInfo);
      } else {
        carInfoDataSource.addCarInfo(carInfo);
        return Tuple(QrScanState.NEW, carInfo);
      }
    } on Exception catch (e) {
      print("Logging: ERROR ${e.toString()}");
    }
    return Tuple(QrScanState.DAFUQ, null);
  }

  Future<bool> _isOldCar(CarInfo carInfo) async {
    final allCars = await carInfoDataSource.getAllCars();
    return allCars.any((car) => car.name == carInfo.name);
  }
}
