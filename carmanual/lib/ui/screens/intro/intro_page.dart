import 'dart:async';

import 'package:carmanual/core/environment_config.dart';
import 'package:carmanual/core/navigation/navi.dart';
import 'package:carmanual/models/car_info.dart';
import 'package:carmanual/service/car_info_service.dart';
import 'package:carmanual/ui/screens/home/home_page.dart';
import 'package:carmanual/ui/widgets/debug/debug_skip_button.dart';
import 'package:carmanual/ui/widgets/qr_camera_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  QrScanState state = QrScanState.WAITING;

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
          child: Center(
              child: Text(state == QrScanState.WAITING
                  ? l10n.introPageMessage
                  : "Scan neu")),
        ),
        Expanded(
          flex: 7,
          child: QRCameraView((barcode) => onScan(barcode.code ?? "")),
        ),
        if (EnvironmentConfig.isDev) SkipDebugButton(onScan),
      ],
    );
  }

  void onScan(String scan) {
    print("Logging: scan: ${scan}");
    widget.service.onNewScan(scan).then((state) {
      print("Logging: state: ${state.first}");
      switch (state.first!) {
        case QrScanState.NEW:
          Navigate.to(context, HomePage.replaceWith());
          break;
        case QrScanState.OLD:
        case QrScanState.DAFUQ:
        case QrScanState.WAITING:
          setState(() {
            this.state = state.first!;
          });
          break;
      }
    });
    ;
  }
}
