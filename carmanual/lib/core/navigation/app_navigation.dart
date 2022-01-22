import 'package:carmanual/core/navigation/app_route_spec.dart';
import 'package:carmanual/ui/screens/home/home_page.dart';
import 'package:carmanual/ui/screens/overview/car_overview_page.dart';
import 'package:carmanual/ui/screens/qr_scan/qr_scan_page.dart';
import 'package:carmanual/ui/snackbars/snackbars.dart';
import 'package:flutter/material.dart';

const routeNames = [
  HomePage.routeName,
  CarOverviewPage.routeName,
  QrScanPage.routeName,
  "Settings",
];

class AppNavigation extends StatefulWidget {
  const AppNavigation(this.routeName, this.onNavigation);

  final String routeName;

  //TODO entfern das
  final void Function(AppRouteSpec routeSpec) onNavigation;

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  final _navigationIcons = const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.video_camera_back),
      label: 'Videos',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.qr_code),
      label: 'QR',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  int? _pageIndex;

  @override
  void initState() {
    super.initState();
    _pageIndex = routeNames.indexOf(widget.routeName);
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
      items: _navigationIcons,
      currentIndex: _pageIndex ?? 0,
      onTap: (index) => _onItemTapped(context, index),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    final isSame = index == _pageIndex;
    if (isSame) {
      showAlreadyHereSnackBar(context);
      return;
    }
    final isEnd = index == _navigationIcons.length - 1;
    if (isEnd) {
      showNothingToSeeSnackBar(context);
      return;
    }
    AppRouteSpec routeSpec;
    final routeName = routeNames[index];
    final thisIsHome = routeNames.indexOf(HomePage.routeName) == _pageIndex;
    switch (routeName) {
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
      default:
        throw Exception("No route found");
    }
    print("Logging: ${routeSpec.name}");
    widget.onNavigation(routeSpec);
  }
}
