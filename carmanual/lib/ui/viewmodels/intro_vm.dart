import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:carmanual/models/car_info_entity.dart';
import 'package:carmanual/service/car_info_service.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../screens/home/home_page.dart';

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
    if (_state.qrState == QrScanState.SCANNING) {
      return;
    }
    _state.qrState = QrScanState.SCANNING;
    notifyListeners();
    //hint: yea we need a delay to disable the camera/qrscan
    Future.delayed(Duration(milliseconds: 10)).then((value) async {
      //TODO 1x then weg
      return await carInfoService.onNewScan(scan).then((state) async {
        _state.qrState = state.firstOrThrow;
        _state.carInfo = state.second;
        switch (_state.qrState) {
          case QrScanState.OLD:
            //hint: only on debug accessible
            navigateTo(HomePage.replaceWith());
            break;
          case QrScanState.NEW:
            navigateTo(HomePage.replaceWith());
            break;
          case QrScanState.DAFUQ:
          case QrScanState.WAITING:
          case QrScanState.SCANNING:
            break;
        }
        notifyListeners();
      });
    });
  }
}
