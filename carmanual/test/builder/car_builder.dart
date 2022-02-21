import 'dart:convert';
import 'dart:io';

import 'package:carmanual/models/car_info_entity.dart';

const String TEST_CAR_MAJA = "car_info_maja.json";

Future<CarInfo> buildCarInfo({String carJsonName = TEST_CAR_MAJA}) async {
  final file = File('test/testdata/$carJsonName').readAsStringSync();
  final json = jsonDecode(file);
  return CarInfo.fromMap(json);
}
