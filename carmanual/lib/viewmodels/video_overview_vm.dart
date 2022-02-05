import 'package:carmanual/core/database/video_info.dart';
import 'package:carmanual/core/datasource/VideoInfoDataSource.dart';
import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:provider/provider.dart';

class VideoOverViewModelProvider
    extends ChangeNotifierProvider<VideoOverViewModel> {
  VideoOverViewModelProvider(VideoInfoDataSource videoInfoSource)
      : super(create: (_) => VideoOverVM(videoInfoSource));
}

abstract class VideoOverViewModel extends ViewModel {
  Stream<List<VideoInfo>> watchVideos();
}

class VideoOverVM extends VideoOverViewModel {
  VideoInfoDataSource _videoInfoSource;

  VideoOverVM(this._videoInfoSource);

  @override
  Stream<List<VideoInfo>> watchVideos() async* {
    final videos = await _videoInfoSource.getVideos();
    yield videos.where((vid) => !vid.name.contains("Intro")).toList();
  }
}
