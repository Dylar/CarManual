import 'package:better_player/better_player.dart';
import 'package:carmanual/core/database/video_info.dart';
import 'package:carmanual/core/helper/player_config.dart';
import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:carmanual/core/navigation/navi.dart';
import 'package:carmanual/ui/widgets/loading_overlay.dart';
import 'package:carmanual/viewmodels/video_vm.dart';
import 'package:flutter/material.dart';

class VideoPage extends View<VideoViewModel> {
  static const String routeName = "/VideoPage";
  static const ARG_VIDEO = "video";

  const VideoPage(
    VideoViewModel viewModel, {
    this.aspectRatio,
  }) : super.model(viewModel);

  static AppRouteSpec pushIt({VideoInfo? video}) => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.pushTo,
        arguments: {ARG_VIDEO: video},
      );

  final double? aspectRatio;

  @override
  State<VideoPage> createState() => _VideoPageState(viewModel);
}

class _VideoPageState extends ViewState<VideoPage, VideoViewModel> {
  _VideoPageState(VideoViewModel viewModel) : super(viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(viewModel.title)),
      body: Column(
        children: [
          Flexible(
              child: StreamBuilder<BetterPlayerConfiguration>(
                  stream: viewModel.watchSettings().map((settings) {
                    final vidSettings = settings.videos;
                    return playerConfigFromMap(vidSettings);
                  }),
                  builder: (context, snapshot) {
                    return viewModel.videoInfo == null
                        ? VideoDownload()
                        : BetterPlayer.network(
                            viewModel.videoInfo!.url,
                            betterPlayerConfiguration: snapshot.data,
                          );
                    ;
                  })),
          Spacer(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Was für ein schönes Auto",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VideoDownload extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      opacity: OPACITY_20,
      child: Container(child: Center(child: Icon(Icons.cloud_download))),
    );
  }
}
