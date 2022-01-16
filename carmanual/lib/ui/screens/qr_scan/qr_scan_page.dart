import 'package:carmanual/core/app_navigation.dart';
import 'package:carmanual/ui/widgets/qr_scanner.dart';
import 'package:flutter/material.dart';

class QrScanPage extends StatelessWidget {
  QrScanPage({Key? key, this.title}) : super(key: key);

  static const String routeName = "/qrScanPage";

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title!)),
      body: QRViewExample(),
      bottomNavigationBar: AppNavigation(routeName),
    );
  }
}
