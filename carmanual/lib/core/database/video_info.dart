import 'package:hive/hive.dart';

part 'video_info.g.dart';

@HiveType(typeId: 2)
class VideoInfo extends HiveObject {
  @HiveField(0)
  String name = "";
}
