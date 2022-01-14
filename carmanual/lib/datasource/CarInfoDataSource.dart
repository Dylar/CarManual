import 'dart:async';

import 'package:carmanual/core/database.dart';
import 'package:carmanual/models/car_info.dart';

class CarInfoDataSource {
  CarInfoDataSource(this.database);

  final AppDatabase database;

  final streamController = StreamController<List<CarInfo>>();

  void dispose() {
    streamController.close();
  }

  Stream<List<CarInfo>> watchCarInfo() async* {
    streamController.add(await database.getCarInfos());
    yield* streamController.stream;
  }

  Future<void> addCarInfo(CarInfo note) async {
    database.upsertCarInfo(note);
    streamController.sink.add(await database.getCarInfos());
  }
}
