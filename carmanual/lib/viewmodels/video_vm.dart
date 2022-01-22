import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:carmanual/ui/widgets/error_widget.dart';
import 'package:carmanual/ui/widgets/video_widget.dart';
import 'package:chewie/chewie.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoViewModelProvider extends ChangeNotifierProvider<VideoViewModel> {
  VideoViewModelProvider() : super(create: (_) => VideoVM());
}

abstract class VideoViewModel extends ViewModel {
  ChewieController get controller;

  set url(String url);

  Future get initVideo;

  void onVideoEnd();
}

class VideoVM extends VideoViewModel {
  VideoVM();

  late ChewieController _controller;
  late String _url;
  late Future _initVideo;

  @override
  ChewieController get controller => _controller;

  @override
  set url(String url) => _url = url;

  @override
  Future get initVideo => _initVideo;

  @override
  void init() {
    super.init();
    final videoPlayerController = VideoPlayerController.network(_url);
    _initVideo = videoPlayerController.initialize();
    _controller = ChewieController(
      videoPlayerController: videoPlayerController,
      // aspectRatio: widget.aspectRatio,
      fullScreenByDefault: false,
      showControlsOnInitialize: false,
      autoInitialize: false,
      showOptions: false,
      showControls: true,
      autoPlay: false,
      looping: false,
      errorBuilder: (context, errorMessage) => ErrorInfoWidget(errorMessage),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.videoPlayerController.dispose();
    _controller.dispose();
  }

  @override
  void onVideoEnd() {
    print("Logging: Video end");
    _controller.seekTo(VIDEO_START).then((_) => _controller.pause());
  }
}
