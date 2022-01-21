import 'package:carmanual/core/navigation/app_navigation.dart';
import 'package:carmanual/core/navigation/app_route_spec.dart';
import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:carmanual/ui/screens/error_page.dart';
import 'package:carmanual/ui/widgets/loading_overlay.dart';
import 'package:carmanual/ui/widgets/video_widget.dart';
import 'package:carmanual/viewmodels/video_vm.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends View<VideoViewModel> {
  static const String routeName = "/VideoPage";
  static const ARG_URL = "url";

  const VideoPage(
    VideoViewModel viewModel, {
    this.title,
    this.url,
    this.aspectRatio,
  }) : super.model(viewModel);

  static AppRouteSpec popAndPush({String? url}) => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.popAndPushTo,
        arguments: {ARG_URL: url},
      );

  static AppRouteSpec pushIt({String? url}) => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.pushTo,
        arguments: {ARG_URL: url},
      );

  final String? title;
  final String? url;
  final double? aspectRatio;

  @override
  State<VideoPage> createState() => _VideoPageState(viewModel);
}

class _VideoPageState extends ViewState<VideoPage, VideoViewModel> {
  _VideoPageState(VideoViewModel viewModel) : super(viewModel);

  late ChewieController controller;
  late Future<void> initVideo;

  @override
  void initState() {
    super.initState();
    final videoPlayerController = VideoPlayerController.network(widget.url!);
    initVideo = videoPlayerController.initialize();
    controller = ChewieController(
      videoPlayerController: videoPlayerController,
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
  void dispose() {
    controller.videoPlayerController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title!)),
      body: Column(
        children: [
          Flexible(
            child: FutureBuilder<void>(
                future: initVideo,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return ErrorPage(snapshot.error.toString());
                  }
                  if (snapshot.connectionState != ConnectionState.done) {
                    return LoadingOverlay();
                  }
                  return VideoWidget(
                      controller: controller,
                      onVideoStart: () => print("Logging: Video start"),
                      onVideoEnd: () {
                        print("Logging: Video end");
                        setState(() {
                          controller.seekTo(VIDEO_START);
                        });
                      });
                }),
          ),
          Spacer(),
          Placeholder(fallbackHeight: 200),
        ],
      ),
      bottomNavigationBar: AppNavigation(
        VideoPage.routeName,
        viewModel.navigateTo,
      ),
    );
  }
}
