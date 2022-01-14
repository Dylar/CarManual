import 'dart:async';

import 'package:carmanual/database/database.dart';
import 'package:carmanual/models/car_info.dart';

class CarInfoDataSource {
  CarInfoDataSource(this.database) : assert(database != null);

  final AppDatabase database;

  final streamController = StreamController<List<CarInfo>>();

  void dispose() {
    streamController.close();
  }

  Stream<List<CarInfo>> watchNotes() async* {
    streamController.add(await database.getCarInfos());
    yield* streamController.stream;
  }

  Future<void> addCarInfo(CarInfo note) async {
    database.upsertCarInfo(note);
    streamController.sink.add(await database.getCarInfos());
  }
}
