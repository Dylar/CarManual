import 'package:carmanual/core/constants/debug.dart';
import 'package:carmanual/core/environment_config.dart';
import 'package:carmanual/ui/screens/debug_page.dart';
import 'package:carmanual/ui/screens/home/home_page.dart';
import 'package:carmanual/ui/screens/intro/intro_page.dart';
import 'package:carmanual/ui/screens/overview/car_overview_page.dart';
import 'package:carmanual/ui/screens/qr_scan/qr_scan_page.dart';
import 'package:carmanual/ui/screens/settings_page.dart';
import 'package:carmanual/ui/screens/video/video_page.dart';
import 'package:carmanual/ui/screens/video_settings_page.dart';
import 'package:carmanual/viewmodels/car_overview_vm.dart';
import 'package:carmanual/viewmodels/home_vm.dart';
import 'package:carmanual/viewmodels/intro_vm.dart';
import 'package:carmanual/viewmodels/qr_vm.dart';
import 'package:carmanual/viewmodels/video_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class AppRoute<T> extends Route<T> {
  String get appName;

  String? get viewName;
}

class RouteWrapper<T> extends MaterialPageRoute<T> implements AppRoute<T> {
  RouteWrapper({
    required WidgetBuilder builder,
    required RouteSettings settings,
  }) : super(builder: builder, settings: settings);

  @override
  String get appName => EnvironmentConfig.APP_NAME;

  @override
  String? get viewName => settings.name;

  @override //TODO
  Duration get transitionDuration => Duration.zero;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}

class AppRouter {
  static final RouteObserver<ModalRoute> routeObserver =
      RouteObserver<ModalRoute>();

  static List<Route<dynamic>> generateInitRoute(String initialRoute) {
    late WidgetBuilder builder;
    switch (initialRoute) {
      case DebugPage.routeName:
        builder = _navigateToDebug;
        break;
      case IntroPage.routeName:
        builder = _navigateToIntro;
        break;
      case HomePage.routeName:
        builder = _navigateToHome;
        break;
      //TODO download page?
    }
    return [_wrapRoute(RouteSettings(name: initialRoute), builder)];
  }

  static AppRoute<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments as Map<String, dynamic>? ?? {};
    print("Logging: Route: ${settings.name}");

    late WidgetBuilder builder;
    switch (settings.name) {
      case DebugPage.routeName:
        builder = _navigateToDebug;
        break;
      case SettingsPage.routeName:
        builder = _navigateToSettings;
        break;
      case VideoSettingsPage.routeName:
        builder = _navigateToVideoSettings;
        break;
      case IntroPage.routeName:
        builder = _navigateToIntro;
        break;
      case HomePage.routeName:
        builder = _navigateToHome;
        break;
      case CarOverviewPage.routeName:
        builder = _navigateToCarInfoIndex;
        break;
      case VideoPage.routeName:
        builder = (context) => _navigateToVideo(context, arguments);
        break;
      case QrScanPage.routeName:
        builder = _navigateToQrScan;
        break;
      default:
        throw Exception('Route ${settings.name} not implemented');
    }

    return _wrapRoute(settings, builder);
  }

  static RouteWrapper _wrapRoute(
    RouteSettings settings,
    WidgetBuilder buildWidget,
  ) =>
      RouteWrapper(settings: settings, builder: buildWidget);
}

//------------------Navigate to page------------------//

Widget _navigateToDebug(BuildContext context) {
  return DebugPage();
}

Widget _navigateToSettings(BuildContext context) {
  return SettingsPage();
}

Widget _navigateToVideoSettings(BuildContext context) {
  return VideoSettingsPage();
}

Widget _navigateToIntro(BuildContext context) {
  final vm = Provider.of<IntroViewModel>(context);
  return IntroPage.model(vm);
}

Widget _navigateToHome(BuildContext context) {
  final vm = Provider.of<HomeViewModel>(context);
  return HomePage(vm);
}

Widget _navigateToCarInfoIndex(BuildContext context) {
  final vm = Provider.of<CarOverViewModel>(context);
  return CarOverviewPage.model(vm);
}

Widget _navigateToQrScan(BuildContext context) {
  final vm = Provider.of<QrViewModel>(context);
  return QrScanPage(vm);
}

Widget _navigateToVideo(BuildContext context, Map<String, dynamic> arguments) {
  final title = arguments[VideoPage.ARG_TITLE] ?? DEBUG_INTRO_VID_URL;
  final url = arguments[VideoPage.ARG_URL] ?? DEBUG_INTRO_VID_URL;
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  final vm = Provider.of<VideoViewModel>(context);
  vm.url = url;
  return VideoPage(
    vm,
    title,
    aspectRatio: width / height / 3, //16 / 9
  );
}
