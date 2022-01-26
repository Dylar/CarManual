import 'package:carmanual/core/app_theme.dart';
import 'package:carmanual/core/database/database.dart';
import 'package:carmanual/core/environment_config.dart';
import 'package:carmanual/core/navigation/app_router.dart';
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
        CarOverViewModelProvider(services.carInfoService),
        IntroViewModelProvider(services.carInfoService),
        HomeViewModelProvider(),
        QrViewModelProvider(services.carInfoService),
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
  Future<bool>? loadDb;

  @override
  void initState() {
    super.initState();
    loadDb = initDB();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: loadDb,
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

          final hasData = snapshot.data ?? false;
          return Services.init(
            carInfoService: widget.carInfoService,
            child: AppProviders(
              child: MaterialApp(
                title: env + EnvironmentConfig.APP_NAME,
                theme: appTheme,
                initialRoute:
                    hasData ? HomePage.routeName : IntroPage.routeName,
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

  Future<bool> initDB() async {
    await Future.delayed(Duration(seconds: EnvironmentConfig.isDev ? 1 : 3));
    await (widget.database.isOpen ? Future.value() : widget.database.init());
    return (await widget.carInfoDataSource.getAllCars()).isNotEmpty;
  }
}
