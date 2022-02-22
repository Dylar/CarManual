import 'dart:convert';
import 'dart:io';

Future<TestAppLocalization> getTestL10n({String local = "de"}) async {
  final file = File('lib/l10n/app_$local.arb').readAsStringSync();
  return TestAppLocalization(jsonDecode(file));
}

class TestAppLocalization {
  const TestAppLocalization(this._values);

  final Map<String, dynamic> _values;

  String get introPageMessage => _values["introPageMessage"];
  String get introPageMessageError => _values["introPageMessageError"];
  String get introPageMessageScanning => _values["introPageMessageScanning"];
}
