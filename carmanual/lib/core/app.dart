import 'package:carmanual/core/app_theme.dart';
import 'package:carmanual/core/datasource/CarInfoDataSource.dart';
import 'package:carmanual/core/datasource/SettingsDataSource.dart';
import 'package:carmanual/core/datasource/VideoInfoDataSource.dart';
import 'package:carmanual/core/datasource/database.dart';
import 'package:carmanual/core/environment_config.dart';
import 'package:carmanual/core/helper/player_config.dart';
import 'package:carmanual/core/navigation/app_router.dart';
import 'package:carmanual/core/network/app_client.dart';
import 'package:carmanual/core/tracking.dart';
import 'package:carmanual/service/car_info_service.dart';
import 'package:carmanual/service/services.dart';
import 'package:carmanual/ui/screens/intro/intro_page.dart';
import 'package:carmanual/ui/screens/intro/loading_page.dart';
import 'package:carmanual/ui/viewmodels/car_overview_vm.dart';
import 'package:carmanual/ui/viewmodels/home_vm.dart';
import 'package:carmanual/ui/viewmodels/intro_vm.dart';
import 'package:carmanual/ui/viewmodels/qr_vm.dart';
import 'package:carmanual/ui/viewmodels/video_overview_vm.dart';
import 'package:carmanual/ui/viewmodels/video_vm.dart';
import 'package:carmanual/ui/widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../ui/screens/home/home_page.dart';
import '../ui/viewmodels/dir_vm.dart';

class AppInfrastructure {
  AppInfrastructure({
    required this.database,
    required this.appClient,
    required this.settings,
    required this.carInfoService,
    required this.carInfoDataSource,
    required this.videoInfoDataSource,
  });

  factory AppInfrastructure.load({
    AppClient? client,
    AppDatabase? database,
    SettingsDataSource? settingsDataSource,
    CarInfoDataSource? carInfoDataSource,
    VideoInfoDataSource? videoInfoDataSource,
  }) {
    final db = database ?? AppDatabase();
    final carSource = carInfoDataSource ?? CarInfoDS(db);
    final videoSource = videoInfoDataSource ?? VideoInfoDS(db);
    final settingsSource = settingsDataSource ?? SettingsDS(db);
    final appClient = client ?? AppClient();
    return AppInfrastructure(
      database: db,
      appClient: appClient,
      settings: settingsSource,
      carInfoDataSource: carSource,
      videoInfoDataSource: videoSource,
      carInfoService: CarInfoService(appClient, carSource, videoSource),
    );
  }

  final AppDatabase database;
  final AppClient appClient;
  final SettingsDataSource settings;
  final CarInfoService carInfoService;
  final CarInfoDataSource carInfoDataSource;
  final VideoInfoDataSource videoInfoDataSource;
}

class App extends StatefulWidget {
  const App({required this.infrastructure}) : super();

  factory App.load() => App(infrastructure: AppInfrastructure.load());

  final AppInfrastructure infrastructure;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        initialData: false,
        future: _initApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            Logger.logD("ERROR - ${snapshot.error.toString()}");
            return fixView(ErrorInfoWidget(snapshot.error.toString()));
          }

          if (snapshot.connectionState != ConnectionState.done) {
            Logger.logD("LOADING");
            return fixView(LoadingStartPage());
          }

          Logger.logD("LOADED");
          final env = EnvironmentConfig.ENV == Env.PROD.name
              ? ""
              : "(${EnvironmentConfig.ENV}) ";

          final bool hasCars = snapshot.data ?? false;
          String firstRoute = IntroPage.routeName;
          if (hasCars) {
            firstRoute = HomePage.routeName;
          }
          // firstRoute = DebugPage.routeName;

          final infra = widget.infrastructure;
          return Services(
            appClient: infra.appClient,
            settings: infra.settings,
            carInfoService: infra.carInfoService,
            child: MultiProvider(
              providers: [
                IntroViewModelProvider(infra.carInfoService),
                HomeViewModelProvider(infra.settings, infra.carInfoService),
                QrViewModelProvider(infra.carInfoService),
                CarOverViewModelProvider(infra.carInfoService),
                VideoOverViewModelProvider(infra.videoInfoDataSource),
                DirViewModelProvider(infra.videoInfoDataSource),
                VideoViewModelProvider(infra.settings),
              ],
              child: MaterialApp(
                title: env + EnvironmentConfig.APP_NAME,
                theme: appTheme,
                // darkTheme: darkAppTheme,
                initialRoute: firstRoute,
                onGenerateInitialRoutes: AppRouter.generateInitRoute,
                onGenerateRoute: AppRouter.generateRoute,
                navigatorObservers: [AppRouter.routeObserver],
                supportedLocales: const [Locale('en'), Locale('de')],
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

  Future<bool> _initApp() async {
    final infra = widget.infrastructure;
    // await Future.delayed(Duration(seconds: EnvironmentConfig.isDev ? 0 : 3));
    await infra.database.init();

    final settings = await infra.settings.getSettings();
    final vidSettings = initPlayerSettings();

    if (settings.videos.isEmpty ||
        settings.videos.length != vidSettings.length) {
      settings.videos = vidSettings;
      infra.settings.saveSettings(settings);
    }

    return await infra.carInfoService.hasCars();
  }
}
