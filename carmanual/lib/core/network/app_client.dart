import 'package:carmanual/core/environment_config.dart';
import 'package:flutter/services.dart';
import 'package:ssh2/ssh2.dart';

import '../tracking.dart';

const String CLIENT_CONNECTED = "sftp_connected";
const String CLIENT_DISCONNECTED = "sftp_disconnected";

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

//TODO download for demand
// Future<String> downloadFile(Callback callback) async {
//   final document = await getApplicationDocumentsDirectory();
//   final path = document.path;
//   print("Log: path: $path");
//
//   final filePath = await client?.sftpDownload(
//     path: "testfile",
//     toPath: path,
//     callback: (progress) {
//       print("Log: progress: " + progress); // read download progress
//       callback(progress);
//     },
//   );
//   print("Log: filePath: $filePath");
//   return filePath ?? "empty";
// }
//
// Future<void> cancelDownload() async {
//   await client?.sftpCancelDownload();
// }
}

class FileData {
  FileData(
    this.modificationDate,
    this.name,
    this.type,
    this.fileSize,
    this.isDir,
  );

  final String modificationDate, name, type;
  final int fileSize;
  final bool isDir;

  static FileData fromMap(Map<String, dynamic> map) {
    final String name = map["filename"] ?? "";
    final type = name.split(".").last;
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
