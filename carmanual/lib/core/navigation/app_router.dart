import 'package:carmanual/core/constants/debug.dart';
import 'package:carmanual/ui/screens/home/home_page.dart';
import 'package:carmanual/ui/screens/intro/intro_page.dart';
import 'package:carmanual/ui/screens/qr_scan/qr_scan_page.dart';
import 'package:carmanual/ui/screens/video/video_page.dart';
import 'package:carmanual/viewmodels/home_vm.dart';
import 'package:carmanual/viewmodels/intro_vm.dart';
import 'package:carmanual/viewmodels/qr_vm.dart';
import 'package:carmanual/viewmodels/video_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../services.dart';

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
  String get appName => 'CarManual';

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
    return [_wrapRoute(RouteSettings(name: initialRoute), _navigateToIntro)];
  }

  static AppRoute<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments as Map<String, dynamic>? ?? {};

    late WidgetBuilder builder;
    switch (settings.name) {
      case IntroPage.routeName:
        builder = _navigateToIntro;
        break;
      case HomePage.routeName:
        builder = _navigateToHome;
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

    print("Logging: ${settings.name}");

    return _wrapRoute(settings, builder);
  }

  static RouteWrapper _wrapRoute(
    RouteSettings settings,
    WidgetBuilder buildWidget,
  ) =>
      RouteWrapper(settings: settings, builder: buildWidget);
}

//------------------Navigate to page------------------//

Widget _navigateToIntro(BuildContext context) {
  final vm = Provider.of<IntroViewModel>(context);
  return IntroPage.model(Services.of(context)!.carInfoService, vm);
}

Widget _navigateToHome(BuildContext context) {
  final vm = Provider.of<HomeViewModel>(context);
  return HomePage(vm, title: AppLocalizations.of(context)!.homoPageTitle);
}

Widget _navigateToVideo(BuildContext context, Map<String, dynamic> arguments) {
  final url = arguments[VideoPage.ARG_URL] ?? DEBUG_VID_URL;
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  final vm = Provider.of<VideoViewModel>(context);
  return VideoPage(
    vm,
    title: "videoPageTitle",
    url: url,
    aspectRatio: width / height / 3, //16 / 9
  );
}

Widget _navigateToQrScan(BuildContext context) {
  final vm = Provider.of<QrViewModel>(context);
  return QrScanPage(vm, title: "qrScanTitle");
}
