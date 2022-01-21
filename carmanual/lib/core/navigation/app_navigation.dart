import 'package:carmanual/core/navigation/app_route_spec.dart';
import 'package:carmanual/ui/screens/home/home_page.dart';
import 'package:carmanual/ui/screens/qr_scan/qr_scan_page.dart';
import 'package:carmanual/ui/screens/video/video_page.dart';
import 'package:flutter/material.dart';

const routeNames = [
  HomePage.routeName,
  VideoPage.routeName,
  QrScanPage.routeName,
  "Settings",
];

class AppNavigation extends StatefulWidget {
  const AppNavigation(this.routeName, this.onNavigation);

  final String routeName;

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
      label: 'Video',
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
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    if (index == _pageIndex || index == _navigationIcons.length - 1) {
      return;
    }
    AppRouteSpec routeSpec;
    final routeName = routeNames[index];
    final isHome = routeName == HomePage.routeName;
    switch (routeName) {
      case HomePage.routeName:
        routeSpec = isHome ? HomePage.popAndRoute() : HomePage.popAndRoute();
        break;
      case VideoPage.routeName:
        routeSpec = VideoPage.pushIt();
        break;
      // case CarIndexPage.routeName:
      //   routeSpec = CarIndexPage.createRouteSpec();
      //   break;
      case QrScanPage.routeName:
        routeSpec = QrScanPage.pushIt();
        break;
      default:
        throw Exception("No route found");
    }
    print("Logging: ${routeSpec.name}");
    widget.onNavigation(routeSpec);
  }
}
