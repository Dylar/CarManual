import 'package:carmanual/models/car_info.dart';
import 'package:hive/hive.dart';

part 'car_info_entity.g.dart';

@HiveType(typeId: 1)
class CarInfoEntity extends HiveObject {
  CarInfoEntity({
    required this.name,
    required this.seller,
    required this.picUrl,
    required this.vidUrl,
  });

  CarInfoEntity.fromCarInfo(CarInfo carInfo) {
    name = carInfo.name;
    seller = carInfo.seller;
    picUrl = carInfo.picUrl;
    vidUrl = carInfo.vidUrl;
  }

  CarInfo toCarInfo() => CarInfo(name, seller, picUrl, vidUrl);

  @HiveField(0)
  String name = "";
  @HiveField(1)
  String seller = "";
  @HiveField(2)
  String picUrl = "";
  @HiveField(3)
  String vidUrl = "";
}
