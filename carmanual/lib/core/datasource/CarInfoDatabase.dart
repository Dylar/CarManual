import 'package:carmanual/core/database/car_info_entity.dart';
import 'package:carmanual/core/database/database.dart';
import 'package:carmanual/models/car_info.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class CarInfoDatabase {
  Future<void> upsertCarInfo(CarInfo carInfo);
  Future<List<CarInfo>> getCarInfos();
  Future<CarInfo?> getCarInfo(String name);
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
