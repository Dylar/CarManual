import 'package:carmanual/core/schema/schema_validater.dart';
import 'package:flutter_test/flutter_test.dart';

import 'builder/entity_builder.dart';

void main() {
  test('validate video info schema', () async {
    final videoInfo = await buildVideoInfo();
    final isValid = await validateVideoInfo(videoInfo);
    expect(isValid, false);
  });

  test('validate sell key schema', () async {
    final key = await buildSellKey();
    final isValid = await validateSellKey(key);
    expect(isValid, false);
  });
}
