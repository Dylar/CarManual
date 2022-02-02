import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:carmanual/core/network/app_client.dart';
import 'package:provider/provider.dart';

class VideoOverViewModelProvider
    extends ChangeNotifierProvider<VideoOverViewModel> {
  VideoOverViewModelProvider(AppClient appClient)
      : super(create: (_) => VideoOverVM(appClient));
}

abstract class VideoOverViewModel extends ViewModel {
  Stream<List<FileData>> watchVideos();
}

// class _VideoOverVMState {
//   QrScanState qrState = QrScanState.WAITING;
//   Barcode? barcode;
//   VideoInfo? VideoInfo;
// }

class VideoOverVM extends VideoOverViewModel {
  AppClient appClient;

  VideoOverVM(this.appClient);

  // final _VideoOverVMState _state = _VideoOverVMState();

  @override
  Stream<List<FileData>> watchVideos() async* {
    yield appClient.files;
  }
}
