import 'package:carmanual/core/environment_config.dart';
import 'package:flutter/services.dart';
import 'package:ssh2/ssh2.dart';

class AppClient {
  SSHClient? client;

  void initClient() {
    print("Log: initClient");
    print("Host: ${EnvironmentConfig.host}");
    print("Port: ${EnvironmentConfig.port}");
    print("User: ${EnvironmentConfig.user}");
    print("PW: ${EnvironmentConfig.pewe}");
    client = SSHClient(
      host: EnvironmentConfig.host,
      port: EnvironmentConfig.port,
      username: EnvironmentConfig.user,
      passwordOrKey: EnvironmentConfig.pewe,
    );
  }

  Future<String> connect() async {
    try {
      String? result = await client?.connect();
      print("Log: connect: $result");
      result = await client?.connectSFTP();
      print("Log: connect SFTP: $result");
      // sftp://
      return result ?? "empty";
    } catch (e) {
      print("Log: ERROR: ${(e as PlatformException).message}");
    }
    return "empty";
  }

  Future<String> disconnect() async {
    return await client?.disconnectSFTP();
  }

  Future<List?> getDirList() async {
    final array = await client?.sftpLs("/home"); // defaults to .
    print("Log: dirs: $array");
    return array;
  }

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
