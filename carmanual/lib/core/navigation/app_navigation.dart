import 'package:carmanual/core/helper/tuple.dart';
import 'package:carmanual/core/navigation/app_route_spec.dart';
import 'package:carmanual/core/navigation/navi.dart';
import 'package:carmanual/ui/screens/home/home_page.dart';
import 'package:carmanual/ui/screens/overview/car_overview_page.dart';
import 'package:carmanual/ui/screens/qr_scan/qr_scan_page.dart';
import 'package:carmanual/ui/screens/settings_page.dart';
import 'package:carmanual/ui/snackbars/snackbars.dart';
import 'package:flutter/material.dart';

final _naviBarData = <Triple<String, String, IconData>>[
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
    _pageIndex = _naviBarData
        .indexWhere((data) => data.firstOrThrow == widget.routeName);
    if (_pageIndex == -1) {
      throw Exception("Route not in list");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.black,
      selectedItemColor: Colors.greenAccent,
      unselectedItemColor: Colors.grey,
      currentIndex: _pageIndex,
      items: _buildIcons(),
      onTap: (index) => _onItemTapped(context, index),
    );
  }

  List<BottomNavigationBarItem> _buildIcons() {
    return _naviBarData
        .map<BottomNavigationBarItem>(
          (data) => BottomNavigationBarItem(
            icon: Icon(data.lastOrThrow),
            label: data.middleOrThrow,
          ),
        )
        .toList();
  }

  void _onItemTapped(BuildContext context, int index) {
    final isSame = index == _pageIndex;
    if (isSame) {
      showAlreadyHereSnackBar(context);
      return;
    }
    final routeName = _naviBarData[index];
    final thisIsHome = _pageIndex == 0;
    AppRouteSpec routeSpec;
    switch (routeName.firstOrThrow) {
      case HomePage.routeName:
        print("Logging: Home tapped");
        routeSpec = HomePage.poopToRoot();
        break;
      case CarOverviewPage.routeName:
        print("Logging: Overview tapped");
        routeSpec = thisIsHome
            ? CarOverviewPage.pushIt()
            : CarOverviewPage.popAndPush();
        break;
      case QrScanPage.routeName:
        print("Logging: QR tapped");
        routeSpec = routeSpec =
            thisIsHome ? QrScanPage.pushIt() : QrScanPage.popAndPush();
        break;
      case SettingsPage.routeName:
        print("Logging: Settings tapped");
        routeSpec = routeSpec =
            thisIsHome ? SettingsPage.pushIt() : SettingsPage.popAndPush();
        break;
      default:
        throw Exception("No route found");
    }
    print("Logging: ${routeSpec.name}");
    Navigate.to(context, routeSpec);
  }
}
