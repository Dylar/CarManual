import 'package:carmanual/core/database/settings.dart';
import 'package:carmanual/core/database/video_info.dart';
import 'package:carmanual/core/datasource/SettingsDataSource.dart';
import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:provider/provider.dart';

class VideoViewModelProvider extends ChangeNotifierProvider<VideoViewModel> {
  VideoViewModelProvider(SettingsDataSource settingsDataSource)
      : super(create: (_) => VideoVM(settingsDataSource));
}

abstract class VideoViewModel extends ViewModel {
  String get title;

  VideoInfo? videoInfo;

  Stream<Settings> watchSettings();
}

class VideoVM extends VideoViewModel {
  VideoVM(this.settings);

  SettingsDataSource settings;

  @override
  String get title => videoInfo?.name.replaceAll(".mp4", "") ?? "";

  @override
  Stream<Settings> watchSettings() {
    return settings.watchSettings();
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
