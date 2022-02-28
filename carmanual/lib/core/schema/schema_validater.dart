import 'package:carmanual/core/helper/json_loader.dart';
import 'package:carmanual/models/video_info.dart';
import 'package:json_schema2/json_schema2.dart';

import '../../models/sell_key.dart';

const BASE_SCHEMA_PATH = "lib/core/schema/";
final VIDEO_INFO_SCHEMA = "video_info_schema.json";
final SELL_KEY_SCHEMA = "sell_key_schema.json";

Future<bool> _validateSchema<T>(T entity, String file) async {
  final schemaFile = await loadJson(BASE_SCHEMA_PATH + file);
  final schema = await JsonSchema.createSchema(schemaFile);
  return schema.validate(entity);
}

Future<bool> validateVideoInfo(VideoInfo videoInfo) async {
  return _validateSchema(videoInfo, VIDEO_INFO_SCHEMA);
}

Future<bool> validateSellKey(SellKey key) async {
  return _validateSchema(key, SELL_KEY_SCHEMA);
}
