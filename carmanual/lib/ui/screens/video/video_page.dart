import 'package:carmanual/core/navigation/app_route_spec.dart';
import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:carmanual/ui/widgets/error_widget.dart';
import 'package:carmanual/ui/widgets/loading_overlay.dart';
import 'package:carmanual/ui/widgets/video_widget.dart';
import 'package:carmanual/viewmodels/video_vm.dart';
import 'package:flutter/material.dart';

class VideoPage extends View<VideoViewModel> {
  static const String routeName = "/VideoPage";
  static const ARG_URL = "url";
  static const ARG_TITLE = "title";

  const VideoPage(
    VideoViewModel viewModel,
    this.title, {
    this.aspectRatio,
  }) : super.model(viewModel);

  static AppRouteSpec pushIt({String? url, String? title}) => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.pushTo,
        arguments: {ARG_URL: url, ARG_TITLE: title},
      );

  final double? aspectRatio;
  final String title;

  @override
  State<VideoPage> createState() => _VideoPageState(viewModel);
}

class _VideoPageState extends ViewState<VideoPage, VideoViewModel> {
  _VideoPageState(VideoViewModel viewModel) : super(viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Flexible(
            child: FutureBuilder<void>(
                future: viewModel.initVideo,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return ErrorInfoWidget(snapshot.error.toString());
                  }
                  if (snapshot.connectionState != ConnectionState.done) {
                    return VideoDownload();
                  }
                  return VideoWidget(
                      controller: viewModel.controller,
                      onVideoStart: () => print("Logging: Video start"),
                      onVideoEnd: viewModel.onVideoEnd);
                }),
          ),
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
