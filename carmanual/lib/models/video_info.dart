import 'dart:convert';

import 'package:carmanual/core/environment_config.dart';
import 'package:carmanual/core/helper/etag.dart';
import 'package:hive/hive.dart';

import '../core/constants/debug.dart';
import 'model_data.dart';

part 'video_info.g.dart';

@HiveType(typeId: VIDEO_INFO_TYPE_ID)
class VideoInfo extends HiveObject {
  VideoInfo({
    required this.name,
    required this.path,
  });

  @HiveField(0)
  String name = "";
  @HiveField(1)
  String path = "";

  static VideoInfo fromMap(Map<String, dynamic> map) => VideoInfo(
        name: map["name"] ?? "Unbekannt",
        path: map["path"] ?? "haha",
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "path": path,
      };

  String toJson() => jsonEncode(toMap());

  String get url {
    //TODO just for bugs
    if (name == "" && path == "") {
      return DEBUG_INTRO_VID_URL;
    }
    return "https://${EnvironmentConfig.domain}$path$name";
  }

  String get asEtag => etag(url);
}
