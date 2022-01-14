import 'package:carmanual/models/car_info.dart';

class DatabaseOpenException implements Exception {}

class DatabaseClosedException implements Exception {}

class AppDatabase {
  bool isOpen = false;
  List<CarInfo> carInfoDB = [];

  void _isDatabaseOpen() {
    if (!isOpen) {
      throw DatabaseClosedException();
    }
  }

  Future<void> close() async {
    _isDatabaseOpen();
    isOpen = false;
  }

  Future<void> init() async {
    if (isOpen) {
      throw DatabaseOpenException();
    }
    isOpen = true;
  }

  void upsertCarInfo(CarInfo carInfo) {
    carInfoDB.add(carInfo);
  }

  Future<List<CarInfo>> getCarInfos() {
    return Future(() => carInfoDB);
  }
}
