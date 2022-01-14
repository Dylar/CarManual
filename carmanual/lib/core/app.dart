import 'package:carmanual/core/app_router.dart';
import 'package:carmanual/core/app_theme.dart';
import 'package:carmanual/core/database.dart';
import 'package:carmanual/core/services.dart';
import 'package:carmanual/datasource/CarInfoDataSource.dart';
import 'package:carmanual/ui/screens/error_page.dart';
import 'package:carmanual/ui/screens/loading_page.dart';
import 'package:carmanual/viewmodels/car_info_vm.dart';
import 'package:carmanual/viewmodels/home_vm.dart';
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
        HomeViewModelProvider(),
        CarInfoViewModelProvider(services.carInfoDataSource),
      ],
      child: child,
    );
  }
}

class App extends StatefulWidget {
  const App({
    required this.database,
    required this.carInfoDataSource,
  }) : super();

  factory App.load({
    AppDatabase? database,
    CarInfoDataSource? notesDataSource,
  }) {
    final db = database ?? AppDatabase();
    return App(
      database: db,
      carInfoDataSource: notesDataSource ?? CarInfoDataSource(db),
    );
  }

  final AppDatabase database;
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
            return Directionality(
              textDirection: TextDirection.ltr,
              child: Center(child: ErrorPage(snapshot.error.toString())),
            );
          }

          if (snapshot.connectionState != ConnectionState.done) {
            return LoadingStartPage();
          }

          return Services.init(
            carInfoDataSource: widget.carInfoDataSource,
            child: AppProviders(
              child: MaterialApp(
                title: 'Car manual',
                theme: appTheme,
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

  Future<void> initDB() async {
    await Future.delayed(Duration(seconds: 2));
    return widget.database.isOpen ? Future.value() : widget.database.init();
  }
}
