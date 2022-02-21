import 'package:carmanual/core/datasource/VideoInfoDataSource.dart';
import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:carmanual/models/car_info_entity.dart';
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

  List<String> getDirs();

  void selectDir(String dir);
}

class DirVM extends DirViewModel {
  DirVM(this._videoSource);

  final VideoInfoDataSource _videoSource;

  late CarInfo selectedCar;

  List<VideoInfo> videos = [];
  List<String> dirs = [];

  @override
  String get title => "${selectedCar.brand} ${selectedCar.model}";

  @override
  void init() {
    super.init();
    _videoSource.getVideos(selectedCar).then((value) {
      print("ALL VIDEOS: ${value.length}");
      dirs = value
          .map<String>((vid) {
            //TODO make this anders
            return vid.path.replaceAll(
                "Videos/${selectedCar.brand}/${selectedCar.model}/", "");
          })
          .toSet()
          .toList();
      dirs.forEach((element) {
        print(element);
      });
      notifyListeners();
    });
  }

  @override
  List<String> getDirs() {
    return dirs;
  }

  @override
  void selectDir(String dir) {
    navigateTo(VideoOverviewPage.pushIt(selectedCar, dir));
  }
}
