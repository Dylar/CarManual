import 'package:carmanual/core/database/car_info_entity.dart';
import 'package:carmanual/core/database/settings.dart';
import 'package:carmanual/core/database/video_info.dart';
import 'package:carmanual/core/datasource/CarInfoDatabase.dart';
import 'package:carmanual/core/datasource/SettingsDatabase.dart';
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
    if (isOpen) {
      throw DatabaseOpenException();
    }
    isOpen = true;

    final document = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(document.path);
    Hive.registerAdapter(CarInfoEntityAdapter());
    await Hive.openBox<Settings>(BOX_SETTINGS);
    await Hive.openBox<CarInfoEntity>(BOX_CAR_INFO);
    await Hive.openBox<VideoInfo>(BOX_VIDEO_INFO);
  }

  Future<void> close() async {
    _isDatabaseOpen();
    isOpen = false;
    await Hive.close();
  }
}
