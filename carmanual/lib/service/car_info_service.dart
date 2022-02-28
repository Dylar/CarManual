import 'dart:convert';

import 'package:carmanual/core/datasource/CarInfoDataSource.dart';
import 'package:carmanual/core/datasource/VideoInfoDataSource.dart';
import 'package:carmanual/core/helper/tuple.dart';
import 'package:carmanual/core/network/app_client.dart';
import 'package:carmanual/core/tracking.dart';
import 'package:carmanual/models/car_info.dart';
import 'package:carmanual/models/video_info.dart';

enum QrScanState { NEW, OLD, DAFUQ, WAITING, SCANNING }

class CarInfoService {
  CarInfoService(
      this._appClient, this.carInfoDataSource, this._videoInfoDataSource);

  final AppClient _appClient;
  final CarInfoDataSource carInfoDataSource; //TODO private
  final VideoInfoDataSource _videoInfoDataSource;

  Future<Tuple<QrScanState, CarInfo>> onNewScan(String scan) async {
    Logger.logI("scan: $scan");
    try {
      Map<String, dynamic> infoMap = jsonDecode(scan);
      final carInfo = CarInfo.fromMap(infoMap);
      final isOldCar = await _isOldCar(carInfo);
      if (isOldCar) {
        return Tuple(QrScanState.OLD, carInfo);
      } else {
        carInfoDataSource.addCarInfo(carInfo);
        await loadVideoInfo(carInfo);
        return Tuple(QrScanState.NEW, carInfo);
      }
    } on Exception catch (e) {
      Logger.logE("scan: ${e.toString()}");
    }
    return Tuple(QrScanState.DAFUQ, null);
  }

  Future<bool> _isOldCar(CarInfo carInfo) async {
    final allCars = await carInfoDataSource.getAllCars();
    return allCars
        .any((car) => car.brand == carInfo.brand && car.model == carInfo.model);
  }

  Future<bool> loadVideoInfo(CarInfo carInfo) async {
    final isLoaded = await _videoInfoDataSource.hasVideosLoaded(carInfo);
    if (isLoaded) {
      return true;
    }

    final dir = await _appClient.loadFilesData();
    final list = <Future<void>>[];
    _loadDir(list, dir);
    return Future.wait([...list]).then((value) => true);
  }

  Future<void> _loadDir(List<Future<void>> list, DirData data) async {
    list.addAll(data.files.map<Future<bool>>(
      (video) {
        final vid = VideoInfo(name: video.name, path: data.path);
        return _videoInfoDataSource.upsertVideo(vid);
      },
    ));
    data.dirs.forEach((dir) => _loadDir(list, dir));
  }

  Future<VideoInfo> getIntroVideo() async {
    final cars = await carInfoDataSource.getAllCars();
    final videos = await _videoInfoDataSource
        .getVideos(cars.last); //TODO make for many cars
    return videos.firstWhere(
        (video) => video.name.toLowerCase().contains("intro"),
        orElse: () => VideoInfo(name: "empty", path: "No path"));
  }

  Future<bool> hasCars() async {
    final List<CarInfo> cars = await carInfoDataSource.getAllCars();
    if (cars.isEmpty) {
      return false;
    }
    await Future.forEach<CarInfo>(cars, (car) async => loadVideoInfo(car));
    return true;
  }
}
