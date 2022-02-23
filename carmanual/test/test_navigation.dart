import 'package:carmanual/core/app.dart';
import 'package:flutter_test/flutter_test.dart';

import 'builder/app_builder.dart';
import 'test_checker.dart';

Future<void> loadApp(WidgetTester tester, {AppInfrastructure? infra}) async {
  // Build our app and trigger a frame.
  final appWidget = await buildTestApp(infra: infra);
  await tester.pumpWidget(appWidget);
  for (int i = 0; i < 30; i++) {
    await tester.pump(Duration(seconds: 1));
  }
}

Future<void> initNavigateToIntro(WidgetTester tester,
    {AppInfrastructure? infra}) async {
  await loadApp(tester, infra: infra);
  checkIntroPage();
}

Future<void> initNavigateToHome(WidgetTester tester,
    {AppInfrastructure? infra}) async {
  await loadApp(tester, infra: infra);
  checkHomePage();
}
