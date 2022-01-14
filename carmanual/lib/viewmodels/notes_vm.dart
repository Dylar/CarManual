import 'dart:async';

import 'package:carmanual/datasource/CarInfoDataSource.dart';
import 'package:carmanual/models/car_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class CarInfoViewModelProvider extends ChangeNotifierProvider<NotesViewModel> {
  CarInfoViewModelProvider(CarInfoDataSource? notesDataSource)
      : super(create: (_) => CarInfoVM(notesDataSource));
}

abstract class NotesViewModel extends ChangeNotifier {
  Stream<List<CarInfo>> get watchCarInfos;

  void dispose();

  Future<void> newCarInfo();
}

class CarInfoVM extends NotesViewModel {
  CarInfoVM(this._carInfoDataSource);

  final CarInfoDataSource? _carInfoDataSource;

  @override
  Stream<List<CarInfo>> get watchCarInfos => _carInfoDataSource!.watchNotes();

  @override
  Future<void> newCarInfo() async {
    final note = CarInfo(DateTime.now().toString());
    await _carInfoDataSource!.addCarInfo(note);
  }
}
