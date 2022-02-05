import 'dart:convert';

import 'package:carmanual/core/database/video_info.dart';
import 'package:carmanual/core/datasource/CarInfoDataSource.dart';
import 'package:carmanual/core/datasource/VideoInfoDataSource.dart';
import 'package:carmanual/core/helper/tuple.dart';
import 'package:carmanual/core/network/app_client.dart';
import 'package:carmanual/models/car_info.dart';

enum QrScanState { NEW, OLD, DAFUQ, WAITING }

class CarInfoService {
  CarInfoService(this.carInfoDataSource, this._videoInfoDataSource);

  CarInfoDataSource carInfoDataSource; //TODO private
  VideoInfoDataSource _videoInfoDataSource;

  Future<Tuple<QrScanState, CarInfo>> onNewScan(String scan) async {
    print("Logging: scan: $scan");
    try {
      Map<String, dynamic> infoMap = jsonDecode(scan);
      final carInfo = CarInfo.fromMap(infoMap);
      final isOldCar = await _isOldCar(carInfo);
      if (isOldCar) {
        return Tuple(QrScanState.OLD, carInfo);
      } else {
        carInfoDataSource.addCarInfo(carInfo);
        return Tuple(QrScanState.NEW, carInfo);
      }
    } on Exception catch (e) {
      print("Logging: ERROR ${e.toString()}");
    }
    return Tuple(QrScanState.DAFUQ, null);
  }

  Future<bool> _isOldCar(CarInfo carInfo) async {
    final allCars = await carInfoDataSource.getAllCars();
    return allCars.any((car) => car.name == carInfo.name);
  }

  Future<bool> loadVideoInfo() async {
    final isLoaded = await _videoInfoDataSource.hasVideosLoaded();
    if (isLoaded) {
      return true;
    }

    final files = await AppClient().loadFilesData(); //TODO
    final info = files.where((file) => !file.isDir).map<Future<bool>>(
          (video) => _videoInfoDataSource.upsertVideo(
            VideoInfo()..name = video.fileName,
          ),
        );
    return Future.wait([...info]).then((value) => true);
  }

  Future<VideoInfo> getIntroVideo() async {
    final videos = await _videoInfoDataSource.getVideos();
    return videos.firstWhere((video) => video.name.contains("Intro"));
  }

  Future<bool> hasCars() async {
    return (await carInfoDataSource.getAllCars()).isNotEmpty;
  }
}
