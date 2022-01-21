import 'dart:async';

import 'package:carmanual/core/environment_config.dart';
import 'package:carmanual/core/navigation/navi.dart';
import 'package:carmanual/models/car_info.dart';
import 'package:carmanual/service/car_info_service.dart';
import 'package:carmanual/ui/screens/home/home_page.dart';
import 'package:carmanual/ui/widgets/qr_camera_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qr_code_scanner/src/types/barcode.dart';

class IntroPage extends StatefulWidget {
  static const String routeName = "/introPage";

  IntroPage(this.service, {Key? key});

  final CarInfoService service;

  @override
  State<IntroPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<IntroPage> {
  late StreamSubscription<List<CarInfo>> sub;

  bool navi = false;

  get onDebug => null;

  @override
  void initState() {
    super.initState();
    sub = widget.service.carInfoDataSource.watchCarInfo().listen((carInfos) {
      if (!carInfos.isEmpty && !navi) {
        navi = true;
        Navigate.to(context, HomePage.replaceWith())
            .then((value) => navi = false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.introPageTitle)),
      body: _buildBody(context, l10n),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Center(child: Text(l10n.introPageMessage)),
        ),
        Expanded(
          flex: 5,
          child: QRCameraView(onScan),
        ),
        if (EnvironmentConfig.isDev)
          Expanded(
            flex: 1,
            child: TextButton(
              //TODO debuging
              onPressed: () => widget.service.onNewScan(
                  "{\"seller\":\"CarMan\",\"name\":\"CarName\",\"url\":\"https:\/\/flutter.github.io\/assets-for-api-docs\/assets\/videos\/bee.mp4\"}"),
              child: Text("Debug: Skip"),
            ),
          ),
      ],
    );
  }

  void onScan(Barcode barcode) {
    final scan = barcode.code;
    if (scan != null) {
      widget.service.onNewScan(scan);
    }
  }
}
