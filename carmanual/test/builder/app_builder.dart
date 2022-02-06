import 'package:carmanual/core/app.dart';

import '../test_utils.dart';

Future<App> buildTestApp({AppInfrastructure? infra}) async {
  infra ??= TestUtils.defaultTestInfra();
  return App(infrastructure: infra);
}
