import 'package:carmanual/core/navigation/app_view.dart';
import 'package:carmanual/ui/screens/video/video_page.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrViewModelProvider extends ChangeNotifierProvider<QrViewModel> {
  QrViewModelProvider() : super(create: (_) => QrVM());
}

abstract class QrViewModel extends ViewModel {
  Barcode? get barcode;

  void onScan(Barcode barcode);

  void dispose();
}

class QrVM extends QrViewModel {
  Barcode? _barcode;

  @override
  Barcode? get barcode => _barcode;

  @override
  void onScan(Barcode barcode) {
    this._barcode = barcode;
    // notifyListeners();
    print("Logging: URL: ${_barcode?.code}");
    navigateTo(VideoPage.popAndPush(url: _barcode?.code));
  }
}
