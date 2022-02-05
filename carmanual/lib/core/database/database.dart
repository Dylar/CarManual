import 'package:carmanual/core/database/car_info_entity.dart';
import 'package:carmanual/core/database/settings.dart';
import 'package:carmanual/core/database/video_info.dart';
import 'package:carmanual/core/datasource/CarInfoDatabase.dart';
import 'package:carmanual/core/datasource/SettingsDatabase.dart';
import 'package:carmanual/core/datasource/VideoInfoDatabase.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseOpenException implements Exception {}

class DatabaseClosedException implements Exception {}

const String BOX_SETTINGS = "SettingsBox";
const String BOX_CAR_INFO = "CarInfoBox";
const String BOX_VIDEO_INFO = "VideoInfoBox";

class AppDatabase with SettingsDB, CarInfoDB, VideoInfoDB {
  bool isOpen = false;

  void _isDatabaseOpen() {
    if (!isOpen) {
      throw DatabaseClosedException();
    }
  }

  Future<void> init() async {
    print("Logging: init db 1");
    if (isOpen) {
      throw DatabaseOpenException();
    }
    isOpen = true;

    final document = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(document.path);
    print("Logging: init db 2");
    Hive.registerAdapter(CarInfoEntityAdapter());
    Hive.registerAdapter(VideoInfoAdapter());
    Hive.registerAdapter(SettingsAdapter());
    print("Logging: init db 3");
    await Hive.openBox<Settings>(BOX_SETTINGS);
    print("Logging: init db 4");
    await Hive.openBox<CarInfoEntity>(BOX_CAR_INFO);
    print("Logging: init db 5");
    await Hive.openBox<VideoInfo>(BOX_VIDEO_INFO);
    print("Logging: init db 6");
  }

  Future<void> close() async {
    _isDatabaseOpen();
    isOpen = false;
    await Hive.close();
  }
}
