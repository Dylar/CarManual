import 'package:hive/hive.dart';

part 'car_info_entity.g.dart';

const FIELD_SELLER = "seller";
const FIELD_NAME = "name";
const FIELD_PIC_URL = "pic_url";
const FIELD_VID_URL = "vid_url";

@HiveType(typeId: 1)
class CarInfo extends HiveObject {
  CarInfo({
    required this.name,
    required this.seller,
    required this.picUrl,
    required this.vidUrl,
  });

  static CarInfo fromMap(Map<String, dynamic> map) => CarInfo(
        name: map[FIELD_NAME] ?? "Unbekannt",
        seller: map[FIELD_SELLER] ?? "Unbekannt",
        picUrl: map[FIELD_PIC_URL] ?? "",
        vidUrl: map[FIELD_VID_URL] ?? "",
      );

  @HiveField(0)
  String name = "";
  @HiveField(1)
  String seller = "";
  @HiveField(2)
  String picUrl = "";
  @HiveField(3)
  String vidUrl = "";
}
