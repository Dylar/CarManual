import 'package:carmanual/core/app_theme.dart';
import 'package:carmanual/core/database.dart';
import 'package:carmanual/core/environment_config.dart';
import 'package:carmanual/core/navigation/app_router.dart';
import 'package:carmanual/core/services.dart';
import 'package:carmanual/datasource/CarInfoDataSource.dart';
import 'package:carmanual/service/car_info_service.dart';
import 'package:carmanual/ui/screens/error_page.dart';
import 'package:carmanual/ui/screens/intro/intro_page.dart';
import 'package:carmanual/ui/screens/loading_page.dart';
import 'package:carmanual/viewmodels/home_vm.dart';
import 'package:carmanual/viewmodels/qr_vm.dart';
import 'package:carmanual/viewmodels/video_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

class AppProviders extends StatelessWidget {
  const AppProviders({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // final services = Services.of(context)!;
    return MultiProvider(
      providers: [
        HomeViewModelProvider(),
        QrViewModelProvider(),
        VideoViewModelProvider(),
      ],
      child: child,
    );
  }
}

class App extends StatefulWidget {
  const App({
    required this.database,
    required this.carInfoService,
    required this.carInfoDataSource,
  }) : super();

  factory App.load({
    AppDatabase? database,
    CarInfoService? carInfoService,
    CarInfoDataSource? carInfoDataSource,
  }) {
    final db = database ?? AppDatabase();
    final carSource = carInfoDataSource ?? CarInfoDS(db);
    return App(
      database: db,
      carInfoService: carInfoService ?? CarInfoService(carSource),
      carInfoDataSource: carSource,
    );
  }

  final AppDatabase database;
  final CarInfoService carInfoService;
  final CarInfoDataSource carInfoDataSource;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Future<void>? loadDb;

  @override
  void initState() {
    super.initState();
    loadDb = initDB();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: loadDb,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return fixView(ErrorPage(snapshot.error.toString()));
          }

          if (snapshot.connectionState != ConnectionState.done) {
            return fixView(LoadingStartPage());
          }

          final env = EnvironmentConfig.ENV == Env.PROD.name
              ? ""
              : "(${EnvironmentConfig.ENV}) ";

          var navigatorKey = GlobalKey<NavigatorState>();
          return Services.init(
            navigatorKey: navigatorKey,
            carInfoService: widget.carInfoService,
            child: AppProviders(
              child: MaterialApp(
                title: env + EnvironmentConfig.APP_NAME,
                theme: appTheme,
                navigatorKey: navigatorKey,
                initialRoute: IntroPage.routeName,
                onGenerateInitialRoutes: AppRouter.generateInitRoute,
                onGenerateRoute: AppRouter.generateRoute,
                navigatorObservers: [AppRouter.routeObserver],
                supportedLocales: const [
                  Locale('en'),
                  Locale('de'),
                ],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
              ),
            ),
          );
        });
  }

  Directionality fixView(Widget widget) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: widget),
    );
  }

  Future<void> initDB() async {
    await Future.delayed(Duration(seconds: 2));
    return widget.database.isOpen ? Future.value() : widget.database.init();
  }
}
