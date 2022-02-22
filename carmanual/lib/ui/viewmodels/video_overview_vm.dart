import 'package:carmanual/core/datasource/VideoInfoDataSource.dart';
import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:carmanual/models/car_info.dart';
import 'package:carmanual/models/video_info.dart';
import 'package:provider/provider.dart';

class VideoOverViewModelProvider
    extends ChangeNotifierProvider<VideoOverViewProvider> {
  VideoOverViewModelProvider(VideoInfoDataSource videoInfoSource)
      : super(
            create: (_) => VideoOverViewProvider(VideoOverVM(videoInfoSource)));
}

class VideoOverViewProvider extends ViewModelProvider<VideoOverViewModel> {
  VideoOverViewProvider(VideoOverViewModel viewModel) : super(viewModel);
}

abstract class VideoOverViewModel extends ViewModel {
  late CarInfo selectedCar;
  late String selectedDir;

  Stream<List<VideoInfo>> watchVideos();
}

class VideoOverVM extends VideoOverViewModel {
  VideoOverVM(this._videoInfoSource);

  VideoInfoDataSource _videoInfoSource;

  @override
  Stream<List<VideoInfo>> watchVideos() async* {
    final videos = await _videoInfoSource.getVideos(selectedCar);
    yield videos.where((vid) => vid.path.contains(selectedDir)).toList();
  }
}
