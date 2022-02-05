import 'package:carmanual/core/app_theme.dart';
import 'package:carmanual/core/database/database.dart';
import 'package:carmanual/core/datasource/CarInfoDataSource.dart';
import 'package:carmanual/core/datasource/SettingsDataSource.dart';
import 'package:carmanual/core/datasource/VideoInfoDataSource.dart';
import 'package:carmanual/core/environment_config.dart';
import 'package:carmanual/core/helper/player_config.dart';
import 'package:carmanual/core/navigation/app_router.dart';
import 'package:carmanual/core/network/app_client.dart';
import 'package:carmanual/core/services.dart';
import 'package:carmanual/service/car_info_service.dart';
import 'package:carmanual/ui/screens/home/home_page.dart';
import 'package:carmanual/ui/screens/intro/intro_page.dart';
import 'package:carmanual/ui/screens/intro/loading_page.dart';
import 'package:carmanual/ui/widgets/error_widget.dart';
import 'package:carmanual/viewmodels/car_overview_vm.dart';
import 'package:carmanual/viewmodels/home_vm.dart';
import 'package:carmanual/viewmodels/intro_vm.dart';
import 'package:carmanual/viewmodels/qr_vm.dart';
import 'package:carmanual/viewmodels/video_overview_vm.dart';
import 'package:carmanual/viewmodels/video_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({
    required this.database,
    required this.appClient,
    required this.settings,
    required this.carInfoService,
    required this.carInfoDataSource,
    required this.videoInfoDataSource,
  }) : super();

  factory App.load({
    AppDatabase? database,
    SettingsDataSource? settingsDataSource,
    CarInfoService? carInfoService,
    CarInfoDataSource? carInfoDataSource,
  }) {
    final db = database ?? AppDatabase();
    final carSource = carInfoDataSource ?? CarInfoDS(db);
    final appClient = AppClient();
    final videoSource = VideoInfoDS(db);
    return App(
      database: db,
      appClient: appClient,
      settings: settingsDataSource ?? SettingsDS(db),
      carInfoService: carInfoService ?? CarInfoService(carSource, videoSource),
      carInfoDataSource: carSource,
      videoInfoDataSource: videoSource,
    );
  }

  final AppDatabase database;
  final AppClient appClient;
  final SettingsDataSource settings;
  final CarInfoService carInfoService;
  final CarInfoDataSource carInfoDataSource;
  final VideoInfoDataSource videoInfoDataSource;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    print("Logging: build");
    return FutureBuilder<bool>(
        initialData: false,
        future: _initApp(),
        builder: (context, snapshot) {
          print("Logging: load app");
          if (snapshot.hasError) {
            return fixView(ErrorInfoWidget(snapshot.error.toString()));
          }

          if (snapshot.connectionState != ConnectionState.done) {
            return fixView(LoadingStartPage());
          }

          final env = EnvironmentConfig.ENV == Env.PROD.name
              ? ""
              : "(${EnvironmentConfig.ENV}) ";

          final bool hasCars = snapshot.data ?? false;
          print("Logging: hasCars - $hasCars");
          String firstRoute = IntroPage.routeName;
          if (hasCars) {
            firstRoute = HomePage.routeName;
          }
          // firstRoute = DebugPage.routeName;

          return Services(
            appClient: widget.appClient,
            settings: widget.settings,
            carInfoService: widget.carInfoService,
            child: MultiProvider(
              providers: [
                IntroViewModelProvider(widget.carInfoService),
                HomeViewModelProvider(widget.settings, widget.carInfoService),
                QrViewModelProvider(widget.carInfoService),
                CarOverViewModelProvider(widget.carInfoService),
                VideoOverViewModelProvider(widget.videoInfoDataSource),
                VideoViewModelProvider(widget.settings),
              ],
              child: MaterialApp(
                title: env + EnvironmentConfig.APP_NAME,
                theme: appTheme,
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
    await Future.delayed(Duration(seconds: EnvironmentConfig.isDev ? 0 : 3));
    await (widget.database.isOpen ? Future.value() : widget.database.init());

    final settings = await widget.settings.getSettings();
    final vidSettings = initPlayerSettings();

    if (settings.videos.isEmpty ||
        settings.videos.length != vidSettings.length) {
      settings.videos = vidSettings;
      widget.settings.saveSettings(settings);
    }

    return await widget.carInfoService.hasCars();
  }
}
