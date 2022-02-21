import 'dart:io';

import 'package:carmanual/core/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'mocks/path_provider_mock.dart';
import 'mocks/test_mock.dart';
import 'ui/screens/intro_test.mocks.dart';

class TestUtils {
  static Future<void> prepareDependency() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    dotenv.testLoad(fileInput: File('test/.testEnv').readAsStringSync());
    PathProviderPlatform.instance = FakePathProviderPlatform();
  }

  static AppInfrastructure defaultTestInfra() {
    final db = MockAppDatabase();
    final appClient = mockAppClient();
    final settingsSource = mockSettings();
    final carSource = mockCarSource();
    final videoSource = mockVideoSource();
    return AppInfrastructure.load(
        client: appClient,
        database: db,
        settingsDataSource: settingsSource,
        carInfoDataSource: carSource,
        videoInfoDataSource: videoSource);
  }
}
