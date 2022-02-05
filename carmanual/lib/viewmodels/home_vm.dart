import 'package:carmanual/core/database/settings.dart';
import 'package:carmanual/core/database/video_info.dart';
import 'package:carmanual/core/datasource/SettingsDataSource.dart';
import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:carmanual/service/car_info_service.dart';
import 'package:provider/provider.dart';

class HomeViewModelProvider extends ChangeNotifierProvider<HomeViewModel> {
  HomeViewModelProvider(
      SettingsDataSource settings, CarInfoService carInfoService)
      : super(create: (_) => HomeVM(settings, carInfoService));
}

abstract class HomeViewModel extends ViewModel {
  VideoInfo? introVideo;
  Stream<Settings> watchSettings();
}

class HomeVM extends HomeViewModel {
  HomeVM(
    this.settings,
    this.carInfoService,
  );

  final SettingsDataSource settings;
  final CarInfoService carInfoService;

  @override
  void init() {
    super.init();
    Future.wait([
      initVideo(),
    ]).then((value) => notifyListeners());
  }

  Future<void> initVideo() async {
    introVideo = await carInfoService.getIntroVideo();
  }

  @override
  Stream<Settings> watchSettings() {
    return settings.watchSettings();
  }
}
