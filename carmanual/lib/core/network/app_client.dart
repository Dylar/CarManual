import 'package:carmanual/core/environment_config.dart';
import 'package:flutter/services.dart';
import 'package:ssh2/ssh2.dart';

const String CLIENT_CONNECTED = "sftp_connected";
const String CLIENT_DISCONNECTED = "sftp_disconnected";

class AppClient {
  SSHClient? client;

  String? state;

  void initClient() {
    print("Log: initClient");
    client = SSHClient(
      host: EnvironmentConfig.host,
      port: EnvironmentConfig.port,
      username: EnvironmentConfig.user,
      passwordOrKey: EnvironmentConfig.pewe,
    );
  }

  Future<String> connect() async {
    try {
      state = await client?.connect();
      state = await client?.connectSFTP();
      print("Log: connect SFTP: $state");
      return state ?? "";
    } catch (e) {
      print("Log: ERROR: ${(e as PlatformException).message}");
    }
    return "";
  }

  Future<String> disconnect() async {
    state = await client?.disconnect();
    state = await client?.disconnectSFTP();
    print("Log: disconnect SFTP: $state");
    return state ?? "DAFUQ";
  }

  Future<List<FileData>> getFileList({String path = "/"}) async {
    final dirs = await client?.sftpLs(path);
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

  Future<List<FileData>> loadFilesData() async {
    print("Logging: loadFilesData");
    initClient();
    await connect();
    List<FileData> files = await getFileList();
    disconnect();
    return files;
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
    this.fileName,
    this.fileSize,
    this.isDir,
  );

  final String modificationDate, fileName;
  final int fileSize;
  final bool isDir;

  static FileData fromMap(Map<String, dynamic> map) {
    return FileData(
      map["modificationDate"] ?? "",
      map["filename"] ?? "",
      int.tryParse(map["fileSize"]) ?? 0,
      map["isDirectory"] == "true",
    );
  }
}
