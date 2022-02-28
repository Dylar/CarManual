import 'package:carmanual/core/helper/json_loader.dart';
import 'package:carmanual/models/sell_key.dart';
import 'package:carmanual/models/video_info.dart';

const String BASE_TESTDATA_PATH = "test/testdata/";
const String TEST_CAR_MAJA = "car_info_maja.json";
const String TEST_VIDEO_INFO = "video_info.json";
const String SELL_KEY = "sell_key.json";

// Future<CarInfo> buildCarInfo({String name = TEST_CAR_MAJA}) async {
//   final json = await loadJson('$BASE_TESTDATA_PATH$name');
//   return CarInfo.fromMap(json);
// }

Future<VideoInfo> buildVideoInfo({String name = TEST_VIDEO_INFO}) async {
  final json = await loadJson('$BASE_TESTDATA_PATH$name');
  return VideoInfo.fromMap(json);
}

Future<SellKey> buildSellKey({String name = SELL_KEY}) async {
  final json = await loadJson('$BASE_TESTDATA_PATH$name');
  return SellKey.fromMap(json);
}
