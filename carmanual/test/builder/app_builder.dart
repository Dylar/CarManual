import 'package:carmanual/core/app.dart';

import '../utils/test_utils.dart';

Future<App> buildTestApp({AppInfrastructure? infra}) async {
  infra ??= TestUtils.defaultTestInfra();
  return App(infrastructure: infra);
}
