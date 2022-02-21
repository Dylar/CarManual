import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:carmanual/models/car_info_entity.dart';
import 'package:carmanual/service/car_info_service.dart';
import 'package:carmanual/ui/screens/overview/car_overview_page.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrViewModelProvider extends ChangeNotifierProvider<QrProvider> {
  QrViewModelProvider(CarInfoService carInfoService)
      : super(create: (_) => QrProvider(QrVM(carInfoService)));
}

class QrProvider extends ViewModelProvider<QrViewModel> {
  QrProvider(QrViewModel viewModel) : super(viewModel);
}

abstract class QrViewModel extends ViewModel {
  QrScanState get qrState;

  Barcode? get barcode;

  CarInfo? get carInfo;

  void onScan(Barcode barcode);
}

class _QrVMState {
  QrScanState qrState = QrScanState.WAITING;
  Barcode? barcode;
  CarInfo? carInfo;
}

class QrVM extends QrViewModel {
  CarInfoService carInfoService;

  QrVM(this.carInfoService);

  final _QrVMState _state = _QrVMState();

  @override
  QrScanState get qrState => _state.qrState;

  @override
  Barcode? get barcode => _state.barcode;

  @override
  CarInfo? get carInfo => _state.carInfo;

  @override
  void onScan(Barcode barcode) {
    this._state.barcode = barcode;
    final data = barcode.code ?? "";
    _state.qrState = QrScanState.SCANNING;
    //hint: yea we need a delay to disable the camera/qrscan
    Future.delayed(Duration(milliseconds: 10)).then((value) async {
      //TODO 1x then weg
      return await carInfoService.onNewScan(data).then((state) {
        _state.qrState = state.first!;
        _state.carInfo = state.second;
        switch (_state.qrState) {
          case QrScanState.NEW:
            navigateTo(CarOverviewPage.popAndPush());
            break;
          case QrScanState.OLD:
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
