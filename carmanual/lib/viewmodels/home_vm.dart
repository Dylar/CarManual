import 'package:carmanual/core/constants/debug.dart';
import 'package:carmanual/viewmodels/video_vm.dart';
import 'package:provider/provider.dart';

class HomeViewModelProvider extends ChangeNotifierProvider<HomeViewModel> {
  HomeViewModelProvider() : super(create: (_) => HomeVM());
}

abstract class HomeViewModel extends VideoVM {}

class HomeVM extends HomeViewModel {
  @override
  void init() {
    url = DEBUG_INTRO_VID_URL;
    super.init();
    controller.setLooping(true);
    controller.play();
  }
}
