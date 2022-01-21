import 'package:carmanual/core/navigation/app_view.dart';
import 'package:provider/provider.dart';

class VideoViewModelProvider extends ChangeNotifierProvider<VideoViewModel> {
  VideoViewModelProvider() : super(create: (_) => VideoVM());
}

abstract class VideoViewModel extends ViewModel {
  // Stream<List<Video>> get watchVideos;
  //
  // Future<void> newVideo();
}

class VideoVM extends VideoViewModel {
  // VideoVM(this._VideoDataSource);

  // @override
  // Stream<List<Video>> get watchVideos => _VideoDataSource!.watchVideo();
  //
  // @override
  // Future<void> newVideo() async {
  //   final note = Video(DateTime.now().toString());
  //   await _VideoDataSource!.addVideo(note);
  // }
}
