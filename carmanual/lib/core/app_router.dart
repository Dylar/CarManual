import 'package:carmanual/ui/screens/home/home_page.dart';
import 'package:carmanual/ui/screens/video/video_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class AppRoute<T> extends Route<T> {
  String get appName;

  String get viewName;
}

class RouteWrapper<T> extends MaterialPageRoute<T> implements AppRoute<T> {
  RouteWrapper({
    @required WidgetBuilder builder,
    @required RouteSettings settings,
  })  : assert(builder != null),
        assert(settings != null),
        super(builder: builder, settings: settings);

  @override
  String get appName => 'CarManual';

  @override
  String get viewName => settings.name;
}

class AppRouter {
  static final RouteObserver<ModalRoute> routeObserver =
      RouteObserver<ModalRoute>();

  static AppRoute<dynamic> generateRoute(RouteSettings settings) {
    final navArgs = settings.arguments;
    WidgetBuilder builder;
    switch (settings.name) {
      case HomePage.routeName:
        builder = _navigateToHome;
        break;
      case VideoPage.routeName:
        builder = (context) => _navigateToVideo(context, navArgs);
        break;
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

Widget _navigateToHome(BuildContext context) {
  return HomePage(
    title: AppLocalizations.of(context).homoPageTitle,
  );
}

Widget _navigateToVideo(BuildContext context, Object navArgs) {
// final url =
//     'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';
  final url =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  return VideoPage(
    title: "videoPageTitle",
    url: url,
    aspectRatio: width / height / 3, //16 / 9
  );
}
