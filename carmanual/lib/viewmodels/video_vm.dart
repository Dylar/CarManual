import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:carmanual/ui/screens/video_settings_page.dart';
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
    print("Logging: init video VM 1");
    final url = _url;
    final videoPlayerController = VideoPlayerController.network(url);
    _initVideo = videoPlayerController.initialize();
    print("Logging: init video VM 2");
    final autoPlay = VIDEO_SETTINGS["autoPlay"];
    print("Logging: $autoPlay");
    _controller = ChewieController(
      videoPlayerController: videoPlayerController,
      // aspectRatio: widget.aspectRatio,
      fullScreenByDefault: false,
      showControlsOnInitialize:
          VIDEO_SETTINGS["showControlsOnInitialize"] ?? false,
      autoInitialize: false,
      showOptions: VIDEO_SETTINGS["showOptions"] ?? false,
      showControls: VIDEO_SETTINGS["showControls"] ?? true,
      autoPlay: VIDEO_SETTINGS["autoPlay"] ?? true,
      looping: VIDEO_SETTINGS["looping"] ?? false,
      errorBuilder: (context, errorMessage) => ErrorInfoWidget(errorMessage),
    );
  }

  @override
  void dispose() {
    _controller.videoPlayerController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void routingDidPushNext() {
    print("video invisible");
    _controller.videoPlayerController.pause();
    _controller.pause();
    super.routingDidPopNext();
  }

  @override
  void routingDidPopNext() {
    print("video visible");
    if (VIDEO_SETTINGS["autoPlay"] ?? true) {
      _controller.videoPlayerController.play();
      _controller.play();
    }
    super.routingDidPop();
  }

  @override
  void onVideoEnd() {
    print("Logging: Video end");
    _controller.seekTo(VIDEO_START).then((_) => _controller.pause());
  }
}
