import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:carmanual/models/car_info.dart';
import 'package:carmanual/service/car_info_service.dart';
import 'package:carmanual/ui/screens/home/home_page.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class CarOverViewModelProvider
    extends ChangeNotifierProvider<CarOverViewModel> {
  CarOverViewModelProvider(CarInfoService carInfoService)
      : super(create: (_) => CarOverVM(carInfoService));
}

abstract class CarOverViewModel extends ViewModel {
  Stream<List<CarInfo>> watchCars();
}

class _CarOverVMState {
  QrScanState qrState = QrScanState.WAITING;
  Barcode? barcode;
  CarInfo? carInfo;
}

class CarOverVM extends CarOverViewModel {
  CarInfoService carInfoService;

  CarOverVM(this.carInfoService);

  final _CarOverVMState _state = _CarOverVMState();

  @override
  Stream<List<CarInfo>> watchCars() {
    return carInfoService.carInfoDataSource.watchCarInfo().asBroadcastStream();
  }

  @override
  void onScan(String scan) {
    print("Logging: scan: ${scan}");
    carInfoService.onNewScan(scan).then((state) {
      _state.qrState = state.first!;
      _state.carInfo = state.second;
      print("Logging: state: ${state.first}");
      switch (state.first!) {
        case QrScanState.NEW:
          navigateTo(HomePage.replaceWith());
          break;
        case QrScanState.OLD:
        case QrScanState.DAFUQ:
        case QrScanState.WAITING:
          notifyListeners();
          break;
      }
    });
  }
}
