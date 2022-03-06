import 'package:carmanual/models/schema_validater.dart';
import 'package:flutter_test/flutter_test.dart';

import 'builder/entity_builder.dart';

void main() {
  test('validate video info schema', () async {
    final videoInfo = await buildVideoInfo();
    final isValid = await validateVideoInfo(videoInfo.toMap());
    expect(isValid, true);
  });

  test('validate sell info schema', () async {
    final sellInfo = await buildSellInfo();
    final isValid = await validateSellInfo(sellInfo.toMap());
    expect(isValid, true);
  });
}
