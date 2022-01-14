import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

const VIDEO_START = Duration(seconds: 0, minutes: 0, hours: 0);

class VideoWidget extends StatefulWidget {
  final ChewieController controller;
  final Function() onVideoStart;
  final Function() onVideoEnd;

  VideoWidget({
    this.controller,
    this.onVideoStart,
    this.onVideoEnd,
  });

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.videoPlayerController.addListener(checkVideo);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.videoPlayerController.removeListener(checkVideo);
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(controller: widget.controller);
  }

  void checkVideo() {
    var playerValue = widget.controller.videoPlayerController.value;
    if (playerValue.position == VIDEO_START) {
      widget.onVideoStart();
    }

    if (playerValue.position == playerValue.duration) {
      widget.onVideoEnd();
    }
  }
}
