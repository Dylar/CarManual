import 'package:carmanual/core/datasource/CarInfoDataSource.dart';
import 'package:carmanual/core/datasource/SettingsDataSource.dart';
import 'package:carmanual/core/datasource/VideoInfoDataSource.dart';
import 'package:carmanual/core/datasource/database.dart';
import 'package:carmanual/core/network/app_client.dart';
import 'package:carmanual/ui/screens/home/home_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import '../../test_checker.dart';
import '../../test_navigation.dart';
import '../../test_utils.dart';

@GenerateMocks([
  AppClient,
  AppDatabase,
  SettingsDataSource,
  CarInfoDataSource,
  VideoInfoDataSource,
])
void main() {
  testWidgets('HomePage - all navigation visible', (WidgetTester tester) async {
    TestUtils.prepareDependency();
    await initNavigateToHome(tester);
    checkNavigationBar(HomePage.routeName);
  });
}
