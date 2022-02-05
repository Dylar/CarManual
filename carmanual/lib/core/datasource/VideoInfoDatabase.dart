import 'package:carmanual/core/database/database.dart';
import 'package:carmanual/core/database/video_info.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class VideoInfoDatabase {
  Future<void> upsertVideoInfo(VideoInfo videoInfo);

  Future<List<VideoInfo>> getVideoInfos();

  Future<VideoInfo?> getVideoInfo(String name);
}

mixin VideoInfoDB implements VideoInfoDatabase {
  Box<VideoInfo> get videoInfoBox => Hive.box<VideoInfo>(BOX_VIDEO_INFO);

  @override
  Future<void> upsertVideoInfo(VideoInfo videoInfo) async {
    await videoInfoBox.put(
      videoInfo.asEtag,
      videoInfo,
    );
  }

  @override
  Future<List<VideoInfo>> getVideoInfos() async {
    return videoInfoBox.values.toList();
  }

  @override
  Future<VideoInfo?> getVideoInfo(String etag) async {
    return videoInfoBox.get(etag);
  }
}
