import 'dart:convert';

import 'package:carmanual/models/video_info.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/environment_config.dart';
import 'model_data.dart';

part 'category_info.g.dart';

@HiveType(typeId: CATEGORY_INFO_TYPE_ID)
class CategoryInfo extends HiveObject {
  CategoryInfo({
    required this.brand,
    required this.model,
    required this.name,
    required this.order,
    required this.description,
    required this.imagePath,
    required this.videos,
  });

  static CategoryInfo fromMap(Map<String, dynamic> map) => CategoryInfo(
        brand: map[FIELD_BRAND] ?? "",
        model: map[FIELD_MODEL] ?? "",
        name: map[FIELD_NAME] ?? "",
        order: map[FIELD_ORDER] ?? 0,
        description: map[FIELD_DESC] ?? "",
        imagePath: map[FIELD_IMAGE_PATH] ?? "",
        videos: map[FIELD_VIDEOS] ?? [],
      );

  Map<String, dynamic> toMap() => {
        FIELD_BRAND: brand,
        FIELD_MODEL: model,
        FIELD_NAME: name,
        FIELD_ORDER: order,
        FIELD_DESC: description,
        FIELD_IMAGE_PATH: imagePath,
        FIELD_VIDEOS: videos,
      };

  String toJson() => jsonEncode(toMap());

  String get picUrl =>
      "https://${EnvironmentConfig.domain}/videos/$brand/$model/$name/$imagePath";

  @HiveField(0)
  String brand = "";
  @HiveField(1)
  String model = "";
  @HiveField(2)
  String name = "";
  @HiveField(3)
  int order = 0;
  @HiveField(4)
  String description = "";
  @HiveField(5)
  String imagePath = "";
  @HiveField(6)
  List<VideoInfo> videos = [];
}
