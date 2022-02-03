import 'package:carmanual/core/datasource/SettingsDataSource.dart';
import 'package:carmanual/core/network/app_client.dart';
import 'package:carmanual/viewmodels/video_vm.dart';
import 'package:provider/provider.dart';

class HomeViewModelProvider extends ChangeNotifierProvider<HomeViewModel> {
  HomeViewModelProvider(SettingsDataSource settings, AppClient appClient)
      : super(create: (_) => HomeVM(appClient, settings));
}

abstract class HomeViewModel extends VideoVM {
  HomeViewModel(SettingsDataSource settingsDataSource, AppClient appClient)
      : super(settingsDataSource);
}

class HomeVM extends HomeViewModel {
  HomeVM(
    this.appClient,
    SettingsDataSource settings,
  ) : super(settings, appClient);

  AppClient appClient;

  @override
  void init() {
    super.init();
    final introFile =
        appClient.files.firstWhere((file) => file.fileName.contains("Intro"));
    url = introFile.url;
    print(introFile.url);
  }
}
