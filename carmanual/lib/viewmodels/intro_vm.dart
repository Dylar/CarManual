import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:carmanual/models/car_info.dart';
import 'package:carmanual/service/car_info_service.dart';
import 'package:carmanual/ui/screens/home/home_page.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class IntroViewModelProvider extends ChangeNotifierProvider<IntroViewModel> {
  IntroViewModelProvider(CarInfoService carInfoService)
      : super(create: (_) => IntroVM(carInfoService));
}

abstract class IntroViewModel extends ViewModel {
  QrScanState get qrState;

  Barcode? get barcode;

  CarInfo? get carInfo;

  void onScan(String scan);

  void dispose();
}

class _IntroVMState {
  QrScanState qrState = QrScanState.WAITING;
  Barcode? barcode;
  CarInfo? carInfo;
}

class IntroVM extends IntroViewModel {
  CarInfoService carInfoService;

  IntroVM(this.carInfoService);

  final _IntroVMState _state = _IntroVMState();

  @override
  QrScanState get qrState => _state.qrState;

  @override
  Barcode? get barcode => _state.barcode;

  @override
  CarInfo? get carInfo => _state.carInfo;

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
