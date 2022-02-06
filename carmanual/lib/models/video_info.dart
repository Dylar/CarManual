import 'package:carmanual/core/environment_config.dart';
import 'package:carmanual/core/helper/etag.dart';
import 'package:hive/hive.dart';

import '../core/constants/debug.dart';

part 'video_info.g.dart';

@HiveType(typeId: 3)
class VideoInfo extends HiveObject {
  @HiveField(0)
  String name = "";
  @HiveField(1)
  String path = "";

  String get url {
    //TODO just for bugs
    if (name == "" && path == "") {
      return DEBUG_INTRO_VID_URL;
    }
    return "https://${EnvironmentConfig.domain}$path$name";
  }

  String get asEtag => etag(url);
}
