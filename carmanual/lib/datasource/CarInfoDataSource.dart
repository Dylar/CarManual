import 'dart:async';

import 'package:carmanual/core/database.dart';
import 'package:carmanual/models/car_info.dart';
import 'package:rxdart/rxdart.dart';

abstract class CarInfoDataSource {
  Stream<List<CarInfo>> watchCarInfo();

  Future<void> addCarInfo(CarInfo info);

  Future<List<CarInfo>> getAllCars();
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
    database.upsertCarInfo(note);
    streamController.sink.add(await database.getCarInfos());
  }

  @override
  Future<List<CarInfo>> getAllCars() async {
    return database.carInfoDB;
  }

  @override
  Stream<List<CarInfo>> watchCarInfo() async* {
    yield* streamController.stream;
    streamController.sink.add(await database.getCarInfos());
  }
}
