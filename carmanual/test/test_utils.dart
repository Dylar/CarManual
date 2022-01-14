import 'package:carmanual/core/app.dart';
import 'package:carmanual/database/database.dart';
import 'package:carmanual/datasource/CarInfoDataSource.dart';
import 'package:mockito/mockito.dart';

class FakeDatabase extends Mock implements AppDatabase {}

class FakeNotesDataSource extends Mock implements CarInfoDataSource {}

class TestUtils {
  static App loadTestApp({
    AppDatabase? database,
    CarInfoDataSource? notesDataSource,
  }) {
    final db = database ?? AppDatabase();
    return App.load(
      database: db,
      notesDataSource: notesDataSource ?? CarInfoDataSource(db),
    );
  }
}
