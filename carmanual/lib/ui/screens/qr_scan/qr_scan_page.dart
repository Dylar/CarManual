import 'package:carmanual/core/navigation/app_navigation.dart';
import 'package:carmanual/core/navigation/app_route_spec.dart';
import 'package:carmanual/core/navigation/app_view.dart';
import 'package:carmanual/service/car_info_service.dart';
import 'package:carmanual/ui/widgets/qr_camera_view.dart';
import 'package:carmanual/viewmodels/qr_vm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QrScanPage extends View<QrViewModel> {
  QrScanPage(QrViewModel viewModel, {Key? key, this.title})
      : super.model(viewModel);

  static const String routeName = "/qrScanPage";

  static AppRouteSpec pushIt() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.pushTo,
      );

  static AppRouteSpec popAndPush() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.popAndPushTo,
      );

  final String? title;

  @override
  State<QrScanPage> createState() => _QrScanPageState(viewModel);
}

class _QrScanPageState extends ViewState<QrScanPage, QrViewModel> {
  _QrScanPageState(QrViewModel viewModel) : super(viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title!)),
      body: _buildBody(context),
      bottomNavigationBar: AppNavigation(
        QrScanPage.routeName,
        viewModel.navigateTo,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: QRCameraView(context.read<QrViewModel>().onScan),
        ),
        Expanded(
          flex: 1,
          child: buildScanInfo(),
        )
      ],
    );
  }

  Widget buildScanInfo() {
    final state = context.watch<QrViewModel>().qrState;
    final carInfo = context.watch<QrViewModel>().carInfo;
    final barcode = context.watch<QrViewModel>().barcode;
    String text;
    switch (state) {
      case QrScanState.NEW:
        text = "Yeah neues Auto";
        break;
      case QrScanState.OLD:
        text = 'Das Auto ${carInfo!.name} hast du schon';
        break;
      case QrScanState.DAFUQ:
        text = barcode == null
            ? "Unbekannter Fehler"
            : 'Barcode Type: ${describeEnum(barcode.format)}\nData: ${barcode.code}';
        break;
      case QrScanState.WAITING:
        text = 'Bitte einen QR Code scannen';
        break;
    }
    return Center(child: Text(text));
  }
}
