import 'dart:convert';

import 'package:hive/hive.dart';

import 'model_data.dart';

part 'car_info.g.dart';

@HiveType(typeId: CAR_INFO_TYPE_ID)
class CarInfo extends HiveObject {
  CarInfo({
    required this.seller,
    required this.brand,
    required this.model,
  });

  static CarInfo fromMap(Map<String, dynamic> map) => CarInfo(
        brand: map[FIELD_BRAND] ?? "",
        model: map[FIELD_MODEL] ?? "",
        seller: map[FIELD_SELLER] ?? "",
      );

  Map<String, dynamic> toMap() => {
        FIELD_BRAND: brand,
        FIELD_MODEL: model,
        FIELD_SELLER: seller,
      };

  String toJson() => jsonEncode(toMap());

  @HiveField(0)
  String brand = "";
  @HiveField(1)
  String model = "";
  @HiveField(2)
  String seller = "";
}
