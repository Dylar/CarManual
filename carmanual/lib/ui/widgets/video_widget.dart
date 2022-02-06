import 'package:better_player/better_player.dart';
import 'package:carmanual/core/database/settings.dart';
import 'package:carmanual/core/helper/player_config.dart';
import 'package:flutter/material.dart';

import 'loading_overlay.dart';

const VIDEO_START = Duration(seconds: 0, minutes: 0, hours: 0);

class VideoWidget extends StatefulWidget {
  final Function()? onVideoStart;
  final Function()? onVideoEnd;

  final Settings settings;
  final String url;

  VideoWidget({
    required this.url,
    required this.settings,
    this.onVideoStart,
    this.onVideoEnd,
  });

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late BetterPlayerController controller;

  bool onStartTriggered = false;

  @override
  void initState() {
    final config = playerConfigFromMap(widget.settings.videos);
    controller = BetterPlayerController(
      config,
      betterPlayerDataSource: BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.url,
      ),
    );
    controller.videoPlayerController!.addListener(checkVideo);
    super.initState();
  }

  @override
  void dispose() {
    print("LOGGING: DISPOSE IT");
    controller.videoPlayerController?.addListener(checkVideo);
    controller.videoPlayerController?.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BetterPlayer(controller: controller);

  void checkVideo() {
    if (!controller.isVideoInitialized()! && !controller.isPlaying()!) {
      return;
    }
    final playerValue = controller.videoPlayerController!.value;
    final position = playerValue.position.inMicroseconds;
    if (!onStartTriggered && position <= VIDEO_START.inMicroseconds) {
      print("LOGGING: onVideoStart");
      onStartTriggered = true;
      widget.onVideoStart?.call();
    }

    final endPosition = playerValue.duration?.inMicroseconds ?? 0;

    if (onStartTriggered && position >= endPosition) {
      print("LOGGING: onVideoEnd");
      onStartTriggered = false;
      widget.onVideoEnd?.call();
    }
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
