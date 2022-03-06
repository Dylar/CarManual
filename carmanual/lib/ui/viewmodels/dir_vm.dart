import 'package:carmanual/core/datasource/VideoInfoDataSource.dart';
import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:carmanual/models/car_info.dart';
import 'package:carmanual/models/category_info.dart';
import 'package:carmanual/models/video_info.dart';
import 'package:carmanual/ui/screens/video/video_overview_page.dart';
import 'package:provider/provider.dart';

class DirViewModelProvider extends ChangeNotifierProvider<DirViewProvider> {
  DirViewModelProvider(VideoInfoDataSource source)
      : super(create: (_) => DirViewProvider(DirVM(source)));
}

class DirViewProvider extends ViewModelProvider<DirViewModel> {
  DirViewProvider(DirViewModel viewModel) : super(viewModel);
}

abstract class DirViewModel extends ViewModel {
  String get title;

  late CarInfo selectedCar;

  List<CategoryInfo> getDirs();

  void selectDir(CategoryInfo dir);
}

class DirVM extends DirViewModel {
  DirVM(this._videoSource);

  final VideoInfoDataSource _videoSource;

  late CarInfo selectedCar;

  List<VideoInfo> videos = [];

  @override
  String get title => "${selectedCar.brand} ${selectedCar.model}";

  @override
  List<CategoryInfo> getDirs() {
    return selectedCar.categories;
  }

  @override
  void selectDir(CategoryInfo dir) {
    navigateTo(VideoOverviewPage.pushIt(selectedCar, dir));
  }
}
