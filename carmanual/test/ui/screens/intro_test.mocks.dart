// Mocks generated by Mockito 5.0.17 from annotations
// in carmanual/test/ui/screens/intro_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i5;

import 'package:carmanual/core/datasource/CarInfoDataSource.dart' as _i10;
import 'package:carmanual/core/datasource/database.dart' as _i6;
import 'package:carmanual/core/datasource/SettingsDataSource.dart' as _i9;
import 'package:carmanual/core/datasource/VideoInfoDataSource.dart' as _i11;
import 'package:carmanual/core/network/app_client.dart' as _i2;
import 'package:carmanual/models/car_info_entity.dart' as _i7;
import 'package:carmanual/models/settings.dart' as _i4;
import 'package:carmanual/models/video_info.dart' as _i8;
import 'package:hive_flutter/hive_flutter.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeDirData_0 extends _i1.Fake implements _i2.DirData {}

class _FakeBox_1<E> extends _i1.Fake implements _i3.Box<E> {}

class _FakeSettings_2 extends _i1.Fake implements _i4.Settings {}

/// A class which mocks [AppClient].
///
/// See the documentation for Mockito's code generation for more information.
class MockAppClient extends _i1.Mock implements _i2.AppClient {
  MockAppClient() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<_i2.DirData> loadFilesData() =>
      (super.noSuchMethod(Invocation.method(#loadFilesData, []),
              returnValue: Future<_i2.DirData>.value(_FakeDirData_0()))
          as _i5.Future<_i2.DirData>);
}

/// A class which mocks [AppDatabase].
///
/// See the documentation for Mockito's code generation for more information.
class MockAppDatabase extends _i1.Mock implements _i6.AppDatabase {
  MockAppDatabase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Box<_i4.Settings> get box => (super.noSuchMethod(Invocation.getter(#box),
      returnValue: _FakeBox_1<_i4.Settings>()) as _i3.Box<_i4.Settings>);
  @override
  _i3.Box<_i7.CarInfo> get carInfoBox =>
      (super.noSuchMethod(Invocation.getter(#carInfoBox),
          returnValue: _FakeBox_1<_i7.CarInfo>()) as _i3.Box<_i7.CarInfo>);
  @override
  _i3.Box<_i8.VideoInfo> get videoInfoBox =>
      (super.noSuchMethod(Invocation.getter(#videoInfoBox),
          returnValue: _FakeBox_1<_i8.VideoInfo>()) as _i3.Box<_i8.VideoInfo>);
  @override
  _i5.Future<void> init() => (super.noSuchMethod(Invocation.method(#init, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i5.Future<void>);
  @override
  _i5.Future<void> close() => (super.noSuchMethod(Invocation.method(#close, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i5.Future<void>);
  @override
  _i5.Future<void> upsertSettings(_i4.Settings? settings) =>
      (super.noSuchMethod(Invocation.method(#upsertSettings, [settings]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i5.Future<void>);
  @override
  _i5.Future<_i4.Settings> getSettings() =>
      (super.noSuchMethod(Invocation.method(#getSettings, []),
              returnValue: Future<_i4.Settings>.value(_FakeSettings_2()))
          as _i5.Future<_i4.Settings>);
  @override
  _i5.Future<void> upsertCarInfo(_i7.CarInfo? carInfo) =>
      (super.noSuchMethod(Invocation.method(#upsertCarInfo, [carInfo]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i5.Future<void>);
  @override
  _i5.Future<List<_i7.CarInfo>> getCarInfos() =>
      (super.noSuchMethod(Invocation.method(#getCarInfos, []),
              returnValue: Future<List<_i7.CarInfo>>.value(<_i7.CarInfo>[]))
          as _i5.Future<List<_i7.CarInfo>>);
  @override
  _i5.Future<_i7.CarInfo?> getCarInfo(String? name) => (super.noSuchMethod(
      Invocation.method(#getCarInfo, [name]),
      returnValue: Future<_i7.CarInfo?>.value()) as _i5.Future<_i7.CarInfo?>);
  @override
  _i5.Future<void> upsertVideoInfo(_i8.VideoInfo? videoInfo) =>
      (super.noSuchMethod(Invocation.method(#upsertVideoInfo, [videoInfo]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i5.Future<void>);
  @override
  _i5.Future<List<_i8.VideoInfo>> getVideoInfos(_i7.CarInfo? carInfo) =>
      (super.noSuchMethod(Invocation.method(#getVideoInfos, [carInfo]),
              returnValue: Future<List<_i8.VideoInfo>>.value(<_i8.VideoInfo>[]))
          as _i5.Future<List<_i8.VideoInfo>>);
  @override
  _i5.Future<_i8.VideoInfo?> getVideoInfo(String? etag) =>
      (super.noSuchMethod(Invocation.method(#getVideoInfo, [etag]),
              returnValue: Future<_i8.VideoInfo?>.value())
          as _i5.Future<_i8.VideoInfo?>);
}

/// A class which mocks [SettingsDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockSettingsDataSource extends _i1.Mock
    implements _i9.SettingsDataSource {
  MockSettingsDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<bool> saveSettings(_i4.Settings? settings) =>
      (super.noSuchMethod(Invocation.method(#saveSettings, [settings]),
          returnValue: Future<bool>.value(false)) as _i5.Future<bool>);
  @override
  _i5.Future<_i4.Settings> getSettings() =>
      (super.noSuchMethod(Invocation.method(#getSettings, []),
              returnValue: Future<_i4.Settings>.value(_FakeSettings_2()))
          as _i5.Future<_i4.Settings>);
  @override
  _i5.Future<Map<String, bool>> getVideoSettings() =>
      (super.noSuchMethod(Invocation.method(#getVideoSettings, []),
              returnValue: Future<Map<String, bool>>.value(<String, bool>{}))
          as _i5.Future<Map<String, bool>>);
  @override
  _i5.Stream<_i4.Settings> watchSettings() => (super.noSuchMethod(
      Invocation.method(#watchSettings, []),
      returnValue: Stream<_i4.Settings>.empty()) as _i5.Stream<_i4.Settings>);
}

/// A class which mocks [CarInfoDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockCarInfoDataSource extends _i1.Mock implements _i10.CarInfoDataSource {
  MockCarInfoDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Stream<List<_i7.CarInfo>> watchCarInfo() =>
      (super.noSuchMethod(Invocation.method(#watchCarInfo, []),
              returnValue: Stream<List<_i7.CarInfo>>.empty())
          as _i5.Stream<List<_i7.CarInfo>>);
  @override
  _i5.Future<void> addCarInfo(_i7.CarInfo? info) =>
      (super.noSuchMethod(Invocation.method(#addCarInfo, [info]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i5.Future<void>);
  @override
  _i5.Future<List<_i7.CarInfo>> getAllCars() =>
      (super.noSuchMethod(Invocation.method(#getAllCars, []),
              returnValue: Future<List<_i7.CarInfo>>.value(<_i7.CarInfo>[]))
          as _i5.Future<List<_i7.CarInfo>>);
}

/// A class which mocks [VideoInfoDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockVideoInfoDataSource extends _i1.Mock
    implements _i11.VideoInfoDataSource {
  MockVideoInfoDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<List<_i8.VideoInfo>> getVideos(_i7.CarInfo? carInfo) =>
      (super.noSuchMethod(Invocation.method(#getVideos, [carInfo]),
              returnValue: Future<List<_i8.VideoInfo>>.value(<_i8.VideoInfo>[]))
          as _i5.Future<List<_i8.VideoInfo>>);
  @override
  _i5.Future<bool> upsertVideo(_i8.VideoInfo? video) =>
      (super.noSuchMethod(Invocation.method(#upsertVideo, [video]),
          returnValue: Future<bool>.value(false)) as _i5.Future<bool>);
  @override
  _i5.Future<bool> hasVideosLoaded(_i7.CarInfo? carInfo) =>
      (super.noSuchMethod(Invocation.method(#hasVideosLoaded, [carInfo]),
          returnValue: Future<bool>.value(false)) as _i5.Future<bool>);
}
