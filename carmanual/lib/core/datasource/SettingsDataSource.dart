import 'dart:async';

import 'package:carmanual/core/database/database.dart';
import 'package:carmanual/core/database/settings.dart';

abstract class SettingsDataSource {
  Future<bool> saveSettings(Settings settings);
  Future<Settings> getSettings();
  Future<Map<String, bool>> getVideoSettings();
}

class SettingsDS implements SettingsDataSource {
  SettingsDS(this._database);

  final AppDatabase _database;

  @override
  Future<Map<String, bool>> getVideoSettings() async {
    final settings = await _database.getSettings();
    return settings.videos;
  }

  @override
  Future<Settings> getSettings() async {
    final settings = await _database.getSettings();
    return settings;
  }

  @override
  Future<bool> saveSettings(Settings settings) async {
    await _database.upsertSettings(settings);
    return true;
  }
}
