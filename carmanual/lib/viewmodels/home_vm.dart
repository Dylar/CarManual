import 'package:carmanual/core/network/app_client.dart';
import 'package:carmanual/viewmodels/video_vm.dart';
import 'package:provider/provider.dart';

class HomeViewModelProvider extends ChangeNotifierProvider<HomeViewModel> {
  HomeViewModelProvider(AppClient appClient)
      : super(create: (_) => HomeVM(appClient));
}

abstract class HomeViewModel extends VideoVM {}

class HomeVM extends HomeViewModel {
  HomeVM(this.appClient);

  AppClient appClient;

  @override
  void init() {
    final introFile =
        appClient.files.firstWhere((file) => file.fileName.contains("Intro"));
    url = introFile.url;
    print(introFile.url);
    super.init();
    controller.setLooping(true);
    controller.play();
  }
}
