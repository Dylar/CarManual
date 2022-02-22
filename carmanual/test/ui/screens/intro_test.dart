import 'package:carmanual/core/datasource/CarInfoDataSource.dart';
import 'package:carmanual/core/datasource/SettingsDataSource.dart';
import 'package:carmanual/core/datasource/VideoInfoDataSource.dart';
import 'package:carmanual/core/datasource/database.dart';
import 'package:carmanual/core/network/app_client.dart';
import 'package:carmanual/ui/screens/intro/intro_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import '../../builder/car_builder.dart';
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
  testWidgets('Load app - got no cars - show intro screen',
      (WidgetTester tester) async {
    TestUtils.prepareDependency();
    await initNavigateToIntro(tester);
  });

  testWidgets('Load app - got cars - show intro screen',
      (WidgetTester tester) async {
    TestUtils.prepareDependency();
    final infra = TestUtils.defaultTestInfra();
    final car = await buildCarInfo();
    await infra.carInfoDataSource.addCarInfo(car);
    await initNavigateToHome(tester, infra: infra);
  });

  testWidgets('Load app - scan bullshit - show error',
      (WidgetTester tester) async {
    TestUtils.prepareDependency();
    await initNavigateToIntro(tester);
    final page = find.byType(IntroPage).evaluate().first.widget as IntroPage;
    // final l10n = await TestUtils.getTestL10n();
    expect(find.text("l10n.introPageMessageError"), findsNothing);
    page.viewModel.onScan("Bullshit");
    await tester.pumpAndSettle();
    expect(find.text("l10n.introPageMessageError"), findsOneWidget);
  });
}
