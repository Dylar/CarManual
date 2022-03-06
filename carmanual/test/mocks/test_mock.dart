import 'package:carmanual/core/datasource/CarInfoDataSource.dart';
import 'package:carmanual/core/datasource/SettingsDataSource.dart';
import 'package:carmanual/core/datasource/VideoInfoDataSource.dart';
import 'package:carmanual/core/network/app_client.dart';
import 'package:carmanual/models/car_info.dart';
import 'package:carmanual/models/settings.dart';
import 'package:carmanual/models/video_info.dart';
import 'package:mockito/mockito.dart';

import '../builder/entity_builder.dart';
import '../ui/screens/intro_test.mocks.dart';

AppClient mockAppClient() {
  final client = MockAppClient();
  final fileDir = DirData("/")
    ..dirs.addAll([
      DirData("toyota/")
        ..files.addAll([
          FileData("Nie", "Intro.mp4", FileType.VIDEO, 23, false),
          FileData("Nie", "WoIsnDerShit.mp4", FileType.VIDEO, 42, false)
        ]),
      DirData("nokia/")
        ..files.addAll([
          FileData("Nie", "Intro.mp4", FileType.VIDEO, 23, false),
          FileData("Nie", "WoIsnDerShit.mp4", FileType.VIDEO, 42, false)
        ]),
    ]);
  when(client.loadFilesData()).thenAnswer((_) async => fileDir);
  when(client.loadCarInfo(any, any))
      .thenAnswer((inv) async => await buildCarInfo());
  return client;
}

SettingsDataSource mockSettings() {
  final source = MockSettingsDataSource();
  var settings = Settings();
  when(source.getSettings()).thenAnswer((_) async => settings);
  when(source.watchSettings()).thenAnswer((_) async* {
    yield settings;
  });
  when(source.saveSettings(settings)).thenAnswer((inv) async {
    settings = inv.positionalArguments.first;
    return true;
  });
  return source;
}

CarInfoDataSource mockCarSource() {
  final source = MockCarInfoDataSource();
  final cars = <CarInfo>[];
  when(source.getAllCars()).thenAnswer((_) async => cars);
  when(source.watchCarInfo()).thenAnswer((_) async* {
    yield cars;
  });
  when(source.addCarInfo(any)).thenAnswer((inv) async {
    cars.add(inv.positionalArguments.first);
  });
  return source;
}

VideoInfoDataSource mockVideoSource() {
  final source = MockVideoInfoDataSource();
  final videos = <VideoInfo>[];
  when(source.getVideos(any)).thenAnswer((inv) async {
    final CarInfo car = inv.positionalArguments.first;
    return videos.where((vid) {
      return vid.vidUrl.contains(car.brand) && vid.vidUrl.contains(car.model);
    }).toList();
  });
  when(source.hasVideosLoaded(any)).thenAnswer((inv) async {
    final CarInfo car = inv.positionalArguments.first;
    return videos.any((vid) {
      return vid.vidUrl.contains(car.brand) && vid.vidUrl.contains(car.model);
    });
  });
  when(source.upsertVideo(any)).thenAnswer((inv) async {
    videos.add(inv.positionalArguments.first);
    return true;
  });
  return source;
}
