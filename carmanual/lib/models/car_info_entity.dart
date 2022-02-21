import 'package:hive/hive.dart';

part 'car_info_entity.g.dart';

const FIELD_BRAND = "brand";
const FIELD_MODEL = "model";
const FIELD_SELLER = "seller";

@HiveType(typeId: 1)
class CarInfo extends HiveObject {
  CarInfo({
    required this.seller,
    required this.brand,
    required this.model,
  });

  static CarInfo fromMap(Map<String, dynamic> map) => CarInfo(
        brand: map[FIELD_BRAND] ?? "Unbekannt",
        model: map[FIELD_MODEL] ?? "",
        seller: map[FIELD_SELLER] ?? "Unbekannt",
      );

  @HiveField(0)
  String brand = "";
  @HiveField(1)
  String model = "";
  @HiveField(2)
  String seller = "";
}
