import 'package:better_player/better_player.dart';
import 'package:carmanual/core/datasource/SettingsDataSource.dart';
import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:provider/provider.dart';

class VideoViewModelProvider extends ChangeNotifierProvider<VideoViewModel> {
  VideoViewModelProvider(SettingsDataSource settingsDataSource)
      : super(create: (_) => VideoVM(settingsDataSource));
}

abstract class VideoViewModel extends ViewModel {
  late BetterPlayerConfiguration videoConfig;

  late String url;

  Future get initVideo;

  void onVideoEnd();
}

class VideoVM extends VideoViewModel {
  VideoVM(this.settingsDataSource);

  SettingsDataSource settingsDataSource;
  late Future _initVideo;

  @override
  Future get initVideo => _initVideo;

  @override
  void init() {
    super.init();
    _initVideo = Future(() async {
      final settings = await settingsDataSource.getVideoSettings();
      videoConfig = BetterPlayerConfiguration(
        // aspectRatio: widget.aspectRatio,
        fullScreenByDefault: false,
        autoPlay: settings["autoPlay"] ?? true,
        looping: settings["looping"] ?? false,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void routingDidPushNext() {
    print("video invisible");
    // _controller.videoPlayerController.pause();
    // _controller.pause();
    super.routingDidPopNext();
  }

  @override
  void routingDidPopNext() {
    print("video visible");
    // if (VIDEO_SETTINGS["autoPlay"] ?? true) {
    // _controller.videoPlayerController.play();
    // _controller.play();
    // }
    super.routingDidPop();
  }

  @override
  void onVideoEnd() {
    print("Logging: Video end");
    // _controller.seekTo(VIDEO_START).then((_) => _controller.pause());
  }
}
