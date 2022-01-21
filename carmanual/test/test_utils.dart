import 'package:carmanual/core/app.dart';
import 'package:carmanual/core/database.dart';
import 'package:carmanual/datasource/CarInfoDataSource.dart';
import 'package:carmanual/service/car_info_service.dart';
import 'package:mockito/mockito.dart';

class FakeDatabase extends Mock implements AppDatabase {}

class FakeNotesDataSource extends Mock implements CarInfoDataSource {}

class TestUtils {
  static App loadTestApp({
    AppDatabase? database,
    CarInfoService? carInfoService,
  }) {
    final db = database ?? AppDatabase();
    return App.load(
      database: db,
      carInfoService: carInfoService ?? CarInfoService(FakeNotesDataSource()),
    );
  }
}
