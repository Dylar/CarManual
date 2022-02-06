import 'package:carmanual/core/environment_config.dart';
import 'package:carmanual/core/helper/etag.dart';
import 'package:hive/hive.dart';

part 'video_info.g.dart';

@HiveType(typeId: 3)
class VideoInfo extends HiveObject {
  @HiveField(0)
  String name = "";

  String get url => "https://${EnvironmentConfig.domain}/$name";

  String get asEtag => etag(name);
}
