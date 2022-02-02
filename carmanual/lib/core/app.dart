import 'package:carmanual/core/app_theme.dart';
import 'package:carmanual/core/database/database.dart';
import 'package:carmanual/core/environment_config.dart';
import 'package:carmanual/core/navigation/app_router.dart';
import 'package:carmanual/core/network/app_client.dart';
import 'package:carmanual/core/services.dart';
import 'package:carmanual/datasource/CarInfoDataSource.dart';
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

class AppProviders extends StatelessWidget {
  const AppProviders({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final services = Services.of(context)!;
    return MultiProvider(
      providers: [
        IntroViewModelProvider(services.carInfoService),
        HomeViewModelProvider(services.appClient),
        QrViewModelProvider(services.carInfoService),
        CarOverViewModelProvider(services.carInfoService),
        VideoOverViewModelProvider(services.appClient),
        VideoViewModelProvider(),
      ],
      child: child,
    );
  }
}

class App extends StatefulWidget {
  const App({
    required this.database,
    required this.appClient,
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
    final appClient = AppClient();
    return App(
      database: db,
      appClient: appClient,
      carInfoService: carInfoService ?? CarInfoService(carSource),
      carInfoDataSource: carSource,
    );
  }

  final AppDatabase database;
  final AppClient appClient;
  final CarInfoService carInfoService;
  final CarInfoDataSource carInfoDataSource;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late Future<bool> initDb;
  late Future<bool> initClient;

  @override
  void initState() {
    super.initState();
    initDb = _initDB();
    initClient = _initAppClient();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<bool>>(
        initialData: [false, false],
        future: Future.wait([initDb, initClient]),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return fixView(ErrorInfoWidget(snapshot.error.toString()));
          }

          if (snapshot.connectionState != ConnectionState.done) {
            return fixView(LoadingStartPage());
          }

          final env = EnvironmentConfig.ENV == Env.PROD.name
              ? ""
              : "(${EnvironmentConfig.ENV}) ";

          final hasData = snapshot.data!.first;
          final isConnected = snapshot.data!.last;

          // String firstRoute = DebugPage.routeName;
          String firstRoute = IntroPage.routeName;
          if (hasData) {
            firstRoute = HomePage.routeName;
            if (!isConnected) {
              firstRoute = HomePage.routeName;
            }
          }
          return Services.init(
            appClient: widget.appClient,
            carInfoService: widget.carInfoService,
            child: AppProviders(
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

  Future<bool> _initDB() async {
    await Future.delayed(Duration(seconds: EnvironmentConfig.isDev ? 0 : 3));
    await (widget.database.isOpen ? Future.value() : widget.database.init());
    return (await widget.carInfoDataSource.getAllCars()).isNotEmpty;
  }

  Future<bool> _initAppClient() async {
    if (widget.appClient.filesInfoLoaded) {
      return true;
    }
    return await widget.appClient.loadFilesData();
  }
}
