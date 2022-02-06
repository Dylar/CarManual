import 'package:carmanual/core/datasource/CarInfoDatabase.dart';
import 'package:carmanual/core/datasource/SettingsDatabase.dart';
import 'package:carmanual/core/datasource/VideoInfoDatabase.dart';
import 'package:carmanual/models/car_info_entity.dart';
import 'package:carmanual/models/settings.dart';
import 'package:carmanual/models/video_info.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../tracking.dart';

class DatabaseOpenException implements Exception {}

class DatabaseClosedException implements Exception {}

const String BOX_SETTINGS = "SettingsBox";
const String BOX_CAR_INFO = "CarInfoBox";
const String BOX_VIDEO_INFO = "VideoInfoBox";

class AppDatabase with SettingsDB, CarInfoDB, VideoInfoDB {
  Future<void> init() async {
    final document = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(document.path);
    try {
      Hive.registerAdapter(CarInfoAdapter());
      Hive.registerAdapter(VideoInfoAdapter());
      Hive.registerAdapter(SettingsAdapter());
    } catch (e) {
      Logger.log("adapter already added");
    }
    await Hive.openBox<Settings>(BOX_SETTINGS);
    await Hive.openBox<CarInfo>(BOX_CAR_INFO);
    await Hive.openBox<VideoInfo>(BOX_VIDEO_INFO);
  }

  Future<void> close() async {
    await Hive.close();
  }
}
