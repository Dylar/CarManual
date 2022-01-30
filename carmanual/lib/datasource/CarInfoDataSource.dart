import 'dart:async';

import 'package:carmanual/core/database/database.dart';
import 'package:carmanual/models/car_info.dart';
import 'package:rxdart/rxdart.dart';

abstract class CarInfoDataSource {
  Stream<List<CarInfo>> watchCarInfo();
  Future<void> addCarInfo(CarInfo info);
  Future<List<CarInfo>> getAllCars();
}

abstract class CarInfoDatabase {
  Future<void> upsertCarInfo(CarInfo carInfo);
  Future<List<CarInfo>> getCarInfos();
  Future<CarInfo?> getCarInfo(String name);
}

class CarInfoDS implements CarInfoDataSource {
  CarInfoDS(this.database);

  final AppDatabase database;

  final streamController = BehaviorSubject<List<CarInfo>>();

  void dispose() {
    streamController.close();
  }

  @override
  Future<void> addCarInfo(CarInfo note) async {
    await database.upsertCarInfo(note);
    streamController.sink.add(await database.getCarInfos());
  }

  @override
  Future<List<CarInfo>> getAllCars() async {
    return database.getCarInfos();
  }

  @override
  Stream<List<CarInfo>> watchCarInfo() {
    database.getCarInfos().then((data) => streamController.add(data));
    return streamController;
  }
}
