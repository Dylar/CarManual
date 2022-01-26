import 'package:carmanual/core/database/car_info_entity.dart';
import 'package:carmanual/datasource/CarInfoDataSource.dart';
import 'package:carmanual/models/car_info.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseOpenException implements Exception {}

class DatabaseClosedException implements Exception {}

const String BOX_SETTINGS = "SettingsBox";
const String BOX_CAR_INFO = "CarInfoBox";

class AppDatabase with CarInfoDB {
  bool isOpen = false;

  void _isDatabaseOpen() {
    if (!isOpen) {
      throw DatabaseClosedException();
    }
  }

  Future<void> init() async {
    if (isOpen) {
      throw DatabaseOpenException();
    }
    isOpen = true;

    final document = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(document.path);
    Hive.registerAdapter(CarInfoEntityAdapter());
    // await Hive.openBox<Settings>(BOX_SETTINGS);
    await Hive.openBox<CarInfoEntity>(BOX_CAR_INFO);
  }

  Future<void> close() async {
    _isDatabaseOpen();
    isOpen = false;
    await Hive.close();
  }
}

mixin CarInfoDB implements CarInfoDatabase {
  Box<CarInfoEntity> get carInfoBox => Hive.box<CarInfoEntity>(BOX_CAR_INFO);

  @override
  Future<void> upsertCarInfo(CarInfo carInfo) async {
    await carInfoBox.put(
      carInfo.name,
      CarInfoEntity.fromCarInfo(carInfo),
    );
  }

  @override
  Future<List<CarInfo>> getCarInfos() async {
    return carInfoBox.values.map<CarInfo>((e) => (e).toCarInfo()).toList();
  }

  @override
  Future<CarInfo?> getCarInfo(String name) async {
    return carInfoBox.get(name)?.toCarInfo();
  }
}
