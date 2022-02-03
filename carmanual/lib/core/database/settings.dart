import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 2)
class Settings extends HiveObject {
  @HiveField(0)
  Map<String, String> values = {};
  @HiveField(1)
  Map<String, bool> videos = {};
}
