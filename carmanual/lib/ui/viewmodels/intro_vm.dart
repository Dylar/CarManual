import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:carmanual/core/tracking.dart';
import 'package:carmanual/models/car_info_entity.dart';
import 'package:carmanual/service/car_info_service.dart';
import 'package:carmanual/ui/screens/home/home_page.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class IntroViewModelProvider extends ChangeNotifierProvider<IntroProvider> {
  IntroViewModelProvider(CarInfoService carInfoService)
      : super(create: (_) => IntroProvider(IntroVM(carInfoService)));
}

class IntroProvider extends ViewModelProvider<IntroViewModel> {
  IntroProvider(IntroViewModel viewModel) : super(viewModel);
}

abstract class IntroViewModel extends ViewModel {
  QrScanState get qrState;

  Barcode? get barcode;

  CarInfo? get carInfo;

  void onScan(String scan);
}

class _IntroVMState {
  QrScanState qrState = QrScanState.WAITING;
  Barcode? barcode;
  CarInfo? carInfo;
  bool isScanned = false;
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
    if (_state.isScanned) {
      return;
    }
    _state.isScanned = true;
    Logger.log("scan: $scan");
    carInfoService.onNewScan(scan).then((state) async {
      _state.isScanned = false;
      _state.qrState = state.first!;
      _state.carInfo = state.second;
      Logger.log("state: ${state.first}");
      switch (state.first!) {
        case QrScanState.OLD:
        case QrScanState.NEW:
          final service = carInfoService;
          await service.loadVideoInfo();
          navigateTo(HomePage.replaceWith());
          break;
        case QrScanState.DAFUQ:
        case QrScanState.WAITING:
          break;
      }
      notifyListeners();
    });
  }
}
