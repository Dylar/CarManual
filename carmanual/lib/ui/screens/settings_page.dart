import 'package:carmanual/core/environment_config.dart';
import 'package:carmanual/core/navigation/app_navigation.dart';
import 'package:carmanual/core/navigation/app_route_spec.dart';
import 'package:carmanual/core/navigation/navi.dart';
import 'package:carmanual/ui/screens/debug_page.dart';
import 'package:carmanual/ui/screens/video_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  static const String routeName = "/settingsPage";

  static AppRouteSpec pushIt() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.pushTo,
      );

  static AppRouteSpec popAndPush() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.popAndPushTo,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsPageTitle),
      ),
      body: _buildBody(context),
      bottomNavigationBar: AppNavigation(SettingsPage.routeName),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        verticalDirection: VerticalDirection.up,
        children: [
          if (EnvironmentConfig.isDev)
            Flexible(child: SettingsButton("Debug", DebugPage.pushIt())),
          Flexible(
              child: SettingsButton(
                  "Video Einstellungen", VideoSettingsPage.pushIt())),
        ],
      ),
    );
  }
}

class SettingsButton extends StatelessWidget {
  SettingsButton(this.name, this.route);

  final AppRouteSpec route;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: () => Navigate.to(context, route),
        child: Text(name),
      ),
    );
  }
}
