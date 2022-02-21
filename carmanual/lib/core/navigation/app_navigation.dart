import 'package:carmanual/core/helper/tuple.dart';
import 'package:carmanual/core/navigation/navi.dart';
import 'package:carmanual/ui/screens/home/home_page.dart';
import 'package:carmanual/ui/screens/overview/car_overview_page.dart';
import 'package:carmanual/ui/screens/qr_scan/qr_scan_page.dart';
import 'package:carmanual/ui/screens/settings/settings_page.dart';
import 'package:carmanual/ui/snackbars/snackbars.dart';
import 'package:flutter/material.dart';

import '../../service/services.dart';
import '../../ui/screens/dir/dir_page.dart';
import '../tracking.dart';

final naviBarData = <Triple<String, String, IconData>>[
  Triple(HomePage.routeName, "Home", Icons.home_outlined),
  Triple(CarOverviewPage.routeName, "Videos", Icons.ondemand_video_sharp),
  Triple(QrScanPage.routeName, "QR", Icons.qr_code_scanner),
  Triple(SettingsPage.routeName, "Settings", Icons.settings),
];

class AppNavigation extends StatefulWidget {
  const AppNavigation(this.routeName);

  final String routeName;

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  late int _pageIndex;

  @override
  void initState() {
    super.initState();
    _pageIndex =
        naviBarData.indexWhere((data) => data.firstOrThrow == widget.routeName);
    if (_pageIndex == -1) {
      throw Exception("Route not in list");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: theme.bottomAppBarTheme.color,
      selectedItemColor: theme.tabBarTheme.labelColor,
      unselectedItemColor: theme.tabBarTheme.unselectedLabelColor,
      currentIndex: _pageIndex,
      items: _buildIcons(),
      onTap: (index) => _onItemTapped(context, index),
    );
  }

  List<BottomNavigationBarItem> _buildIcons() {
    return naviBarData
        .map<BottomNavigationBarItem>(
          (data) => BottomNavigationBarItem(
            icon: Icon(data.lastOrThrow),
            label: data.middleOrThrow,
          ),
        )
        .toList();
  }

  Future<void> _onItemTapped(BuildContext context, int index) async {
    final isSame = index == _pageIndex;
    if (isSame) {
      showAlreadyHereSnackBar(context);
      return;
    }
    final routeName = naviBarData[index];
    final thisIsHome = _pageIndex == 0;
    AppRouteSpec routeSpec;
    switch (routeName.firstOrThrow) {
      case HomePage.routeName:
        Logger.logI("Home tapped");
        routeSpec = HomePage.poopToRoot();
        break;
      case CarOverviewPage.routeName:
        Logger.logI("Videos tapped");
        final cars = await Services.of(context)!
            .carInfoService
            .carInfoDataSource
            .getAllCars();
        if (cars.length == 1) {
          routeSpec = DirPage.pushIt(cars.first);
        } else {
          routeSpec = thisIsHome
              ? CarOverviewPage.pushIt()
              : CarOverviewPage.popAndPush();
        }
        break;
      case QrScanPage.routeName:
        Logger.logI("QR tapped");
        routeSpec = routeSpec =
            thisIsHome ? QrScanPage.pushIt() : QrScanPage.popAndPush();
        break;
      case SettingsPage.routeName:
        Logger.logI("Settings tapped");
        routeSpec = routeSpec =
            thisIsHome ? SettingsPage.pushIt() : SettingsPage.popAndPush();
        break;
      default:
        throw Exception("No route found");
    }
    Logger.logI("Navi to: ${routeSpec.name}");
    Navigate.to(context, routeSpec);
  }
}
