import 'package:carmanual/core/navigation/app_route_spec.dart';
import 'package:flutter/material.dart';

class DebugPage extends StatelessWidget {
  static const String routeName = "/debugPage";

  static AppRouteSpec pushIt() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.pushTo,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Debug screen")),
    );
  }
}
