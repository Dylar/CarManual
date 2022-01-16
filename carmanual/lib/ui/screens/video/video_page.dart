import 'package:carmanual/core/app_navigation.dart';
import 'package:carmanual/ui/widgets/video_widget.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({this.title, this.url, this.aspectRatio});

  static const String routeName = "/VideoPage";

  final String? title;
  final String? url;
  final double? aspectRatio;

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  ChewieController? controller;

  @override
  void initState() {
    super.initState();
    final videoPlayerController = VideoPlayerController.network(widget.url!);
    controller = ChewieController(
      videoPlayerController: videoPlayerController..initialize(),
      // aspectRatio: widget.aspectRatio,
      fullScreenByDefault: false,
      autoInitialize: true,
      showOptions: false,
      showControls: true,
      autoPlay: false,
      looping: false,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title!)),
      body: Column(
        children: [
          Flexible(
            child: VideoWidget(
                controller: controller,
                onVideoStart: () => print("Video start"),
                onVideoEnd: () {
                  print("Video end");
                  setState(() {
                    controller!.seekTo(VIDEO_START);
                  });
                }),
          ),
          Spacer(),
          Placeholder(fallbackHeight: 200),
        ],
      ),
      bottomNavigationBar: AppNavigation(VideoPage.routeName),
    );
  }
}
