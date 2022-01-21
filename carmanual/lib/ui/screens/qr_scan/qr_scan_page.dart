import 'package:carmanual/core/navigation/app_navigation.dart';
import 'package:carmanual/core/navigation/app_route_spec.dart';
import 'package:carmanual/core/navigation/app_view.dart';
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
    final barcode = context.watch<QrViewModel>().barcode;
    return Column(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: QRCameraView(context.read<QrViewModel>().onScan),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: (barcode != null)
                ? Text(
                    'Barcode Type: ${describeEnum(barcode.format)}   Data: ${barcode.code}',
                  )
                : Text('Scan a code'),
          ),
        )
      ],
    );
  }
}
