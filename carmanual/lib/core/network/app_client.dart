import 'dart:convert';
import 'dart:io';

import 'package:carmanual/core/environment_config.dart';
import 'package:carmanual/models/car_info.dart';
import 'package:carmanual/models/category_info.dart';
import 'package:carmanual/models/schema_validater.dart';
import 'package:carmanual/models/video_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ssh2/ssh2.dart';

import '../tracking.dart';

const String CLIENT_CONNECTED = "sftp_connected";
const String CLIENT_DISCONNECTED = "sftp_disconnected";

enum FileType { UNKNOWN, JSON, VIDEO, IMAGE }

class AppClient {
  SSHClient? _client;

  String? _state;

  void _initClient() {
    _client = SSHClient(
      host: EnvironmentConfig.host,
      port: EnvironmentConfig.port,
      username: EnvironmentConfig.user,
      passwordOrKey: EnvironmentConfig.pewe,
    );
  }

  Future<String> _connect() async {
    try {
      _state = await _client?.connect();
      _state = await _client?.connectSFTP();
      Logger.logI("connect SFTP: $_state");
      return _state ?? "";
    } catch (e) {
      Logger.logE("${(e as PlatformException).message}", printTrace: true);
    }
    return "";
  }

  Future<String> _disconnect() async {
    _state = await _client?.disconnect();
    _state = await _client?.disconnectSFTP();
    Logger.logI("disconnect SFTP: $_state");
    return _state ?? "DAFUQ";
  }

  Future<List<FileData>> _getFileList({String path = "/"}) async {
    final dirs = await _client?.sftpLs(path);
    return dirs?.map<FileData>((json) {
          //Hint: its not real json ... so we need to parse shitty
          final splitFields = json.toString().split(",");
          Map<String, dynamic> infoMap = {};
          splitFields.forEach((element) {
            final splitKeyValue = element.split(":");
            final key = splitKeyValue.first;
            String value = "";
            for (int i = 1; i < splitKeyValue.length; i++) {
              if (value != "") {
                value += ":";
              }
              value += splitKeyValue[i];
            }
            infoMap[key.replaceAll("}", "").replaceAll("{", "").trim()] =
                value.replaceAll("}", "").replaceAll("{", "").trim();
          });
          return FileData.fromMap(infoMap);
        }).toList() ??
        [];
  }

  Future<DirData> _loadFileDir(DirData dir) async {
    try {
      List<FileData> initialFiles = await _getFileList(path: dir.path);
      initialFiles.forEach((file) {
        if (file.isDir) {
          final path = dir.path + file.name + "/";
          dir.dirs.add(DirData(path));
        } else {
          dir.files.add(file);
        }
      });
      if (dir.dirs.isNotEmpty) {
        await Future.forEach<DirData>(dir.dirs, (e) => _loadFileDir(e));
      }
    } catch (e) {
      Logger.logE("Path: ${dir.path}");
      Logger.logE("error - ${e.toString()}");
    }

    return dir;
  }

  Future<DirData> loadFilesData() async {
    _initClient();
    await _connect();
    final dirs = await _loadFileDir(DirData("/"));
    _disconnect();
    return dirs;
  }

  Future<CarInfo> loadCarInfo(String? brand, String? model) async {
    Logger.logI("loadCarInfo: $brand, $model");
    final rootDir = await loadFilesData();
    List<DirData> dirs = rootDir.dirs;
    dirs = dirs.firstWhere((dir) => dir.path.contains("Videos")).dirs;
    dirs = dirs.firstWhere((dir) => dir.path.contains(brand ?? "")).dirs;
    final data = dirs.firstWhere((dir) => dir.path.contains(model ?? ""));

    final jsonFile =
        data.files.firstWhere((file) => file.type == FileType.JSON);
    final json = await _loadJsonFile(data.path, jsonFile.name);
    final valid = await validateCarInfo(json);
    if (!valid) {
      throw Exception("Json invalid: $json");
    }
    final car = CarInfo.fromMap(json);
    car.categories.addAll(await _loadCategories(data));

    //TODO delete me if we got the urls right
    car.categories.forEach((category) {
      category.brand = car.brand;
      category.model = car.model;
    });

    return car;
  }

  Future<List<CategoryInfo>> _loadCategories(DirData data) async {
    final allDirs = data.dirs
        .where((dir) => dir.files.any((file) => file.type == FileType.JSON));
    return await Future.wait(allDirs.map((dir) async {
      final jsonFile = dir.files.firstWhere(
        (file) => file.type == FileType.JSON,
      );
      final json = await _loadJsonFile(dir.path, jsonFile.name);
      final valid = await validateCategoryInfo(json);
      if (!valid) {
        throw Exception("Json invalid: $json");
      }
      final category = CategoryInfo.fromMap(json);
      category.videos.addAll(await _loadVideos(dir));
      return category;
    }));
  }

  Future<List<VideoInfo>> _loadVideos(DirData data) async {
    final allDirs = data.dirs
        .where((dir) => dir.files.any((file) => file.type == FileType.JSON));
    return Future.wait(allDirs.map((dir) async {
      final jsonFile =
          dir.files.firstWhere((file) => file.type == FileType.JSON);
      final json = await _loadJsonFile(dir.path, jsonFile.name);
      final valid = await validateVideoInfo(json);
      if (!valid) {
        throw Exception("Json invalid: $json");
      }
      return VideoInfo.fromMap(json);
    }));
  }

  // void _printDirStruct(DirData dir) {
  //   print("DirPath: ${dir.path}");
  //   dir.files.forEach((file) => Logger.logD("dirFiles: " + file.name));
  //   dir.dirs.forEach((dir) => _printDirStruct(dir));
  // }

  Future<Map<String, dynamic>> _loadJsonFile(
      String path, String fileName) async {
    HttpClient httpClient = new HttpClient();
    Map<String, dynamic> result = {};

    try {
      final url = "https://${EnvironmentConfig.domain}";
      final theUrl = url + path + fileName;
      var request = await httpClient.getUrl(Uri.parse(theUrl));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        result = jsonDecode(utf8.decode(bytes));
      } else {
        throw Exception("Error code: " + response.statusCode.toString());
      }
    } catch (ex) {
      throw Exception("Can not fetch url");
    }
    return result;
  }
}

class FileData {
  FileData(
    this.modificationDate,
    this.name,
    this.type,
    this.fileSize,
    this.isDir,
  );

  final String modificationDate, name;
  final FileType type;
  final int fileSize;
  final bool isDir;

  static FileData fromMap(Map<String, dynamic> map) {
    final String name = map["filename"] ?? "";
    final ext = name.split(".").last.toLowerCase();
    FileType type = FileType.UNKNOWN;
    if (["json", "txt"].contains(ext)) {
      type = FileType.JSON;
    } else if (["mp4"].contains(ext)) {
      type = FileType.VIDEO;
    } else if (["jpg", "jpeg", "png"].contains(ext)) {
      type = FileType.IMAGE;
    }
    return FileData(
      map["modificationDate"] ?? "",
      name,
      type,
      int.tryParse(map["fileSize"]) ?? 0,
      map["isDirectory"] == "true",
    );
  }
}

class DirData {
  DirData(this.path);

  final String path;
  final List<DirData> dirs = [];
  final List<FileData> files = [];
}
