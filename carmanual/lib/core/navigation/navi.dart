import 'package:flutter/material.dart';

enum AppRouteAction {
  pushTo,
  popAndPushTo,
  pop,
  popUntil,
  popUntilRoot,
  replaceWith,
  replaceAllWith,
}

class AppRouteSpec {
  /// The route that the `action` will use to perform the action (push,
  /// replace, pop, etc).
  final String name;

  /// Arguments for the route. Arguments for Pop actions are ignored.
  /// Default empty.
  final Map<String, dynamic> arguments;

  /// Defaults to `AppRouteAction.pushTo`
  final AppRouteAction action;

  const AppRouteSpec({
    required this.name,
    this.arguments = const {},
    this.action = AppRouteAction.pushTo,
  });

  const AppRouteSpec.pop()
      : name = '',
        action = AppRouteAction.pop,
        arguments = const {};

  const AppRouteSpec.popUntilRoot()
      : name = '',
        action = AppRouteAction.popUntilRoot,
        arguments = const {};
}

class Navigate {
  static Future<void> to(BuildContext context, AppRouteSpec spec) async {
    switch (spec.action) {
      //TODO complete list
      case AppRouteAction.pushTo:
        await Navigator.of(context).pushNamed(
          spec.name,
          arguments: spec.arguments,
        );
        break;
      case AppRouteAction.popAndPushTo:
        await Navigator.of(context).popAndPushNamed(
          spec.name,
          arguments: spec.arguments,
        );
        break;
      case AppRouteAction.replaceWith:
        await Navigator.of(context).pushReplacementNamed(
          spec.name,
          arguments: spec.arguments,
        );
        break;
      case AppRouteAction.replaceAllWith:
        await Navigator.of(context).pushNamedAndRemoveUntil(
          spec.name,
          (route) => false,
          arguments: spec.arguments,
        );
        break;
      case AppRouteAction.pop:
        Navigator.of(context).pop();
        break;
      case AppRouteAction.popUntil:
        Navigator.of(context)
            .popUntil((route) => route.settings.name == spec.name);
        break;
      case AppRouteAction.popUntilRoot:
        Navigator.of(context).popUntil((route) => route.isFirst);
        break;
      default:
        throw UnsupportedError("Unknown app route action");
    }
  }
}
