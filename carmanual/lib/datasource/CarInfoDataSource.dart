import 'dart:async';

import 'package:carmanual/core/database.dart';
import 'package:carmanual/models/car_info.dart';

abstract class CarInfoDataSource {
  void dispose();

  Stream<List<CarInfo>> watchCarInfo();

  Future<void> addCarInfo(CarInfo info);

  Future<List<CarInfo>> getAllCars();
}

class CarInfoDS implements CarInfoDataSource {
  CarInfoDS(this.database);

  final AppDatabase database;

  final streamController = StreamController<List<CarInfo>>();

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
    streamController.add(await database.getCarInfos());
    yield* streamController.stream;
  }
}
