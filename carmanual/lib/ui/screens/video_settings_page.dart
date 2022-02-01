import 'package:carmanual/core/app_theme.dart';
import 'package:carmanual/core/navigation/app_route_spec.dart';
import 'package:carmanual/ui/widgets/scroll_list_view.dart';
import 'package:flutter/material.dart';

Map<String, bool> VIDEO_SETTINGS = {};

class VideoSettingsPage extends StatefulWidget {
  static const String routeName = "/videoSettingsPage";

  static AppRouteSpec pushIt() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.pushTo,
      );

  @override
  State<VideoSettingsPage> createState() => _VideoSettingsPageState();
}

class _VideoSettingsPageState extends State<VideoSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("VideoSettings")),
      body: ScrollListView<MapEntry<String, bool>>(
        items: VIDEO_SETTINGS.entries.toList(),
        buildItemWidget: (_, item) => wrapWidget(
            item.key, _VideoSettingsInfoText("${item.key}", item.value)),
      ),
    );
  }

  Widget wrapWidget(String key, Widget child) => GestureDetector(
        onTap: () {
          setState(() {
            VIDEO_SETTINGS[key] = !(VIDEO_SETTINGS[key] ?? false);
          });
        },
        child: Container(
          height: 48,
          padding: const EdgeInsets.all(4.0),
          child: child,
        ),
      );
}

class _VideoSettingsInfoText extends StatelessWidget {
  _VideoSettingsInfoText(this.title, this.enabled);

  final String title;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: enabled ? BaseColors.green : BaseColors.red,
          border: Border.all(color: BaseColors.accent)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(alignment: Alignment.centerLeft, child: Text(title)),
          Flexible(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(enabled ? "True" : "False"))),
        ],
      ),
    );
  }
}
