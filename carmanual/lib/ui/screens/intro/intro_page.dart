import 'package:carmanual/core/environment_config.dart';
import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:carmanual/service/car_info_service.dart';
import 'package:carmanual/ui/viewmodels/intro_vm.dart';
import 'package:carmanual/ui/widgets/debug/debug_skip_button.dart';
import 'package:carmanual/ui/widgets/qr_camera_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class IntroPage extends View<IntroViewModel> {
  static const String routeName = "/introPage";

  IntroPage.model(IntroViewModel viewModel) : super.model(viewModel);

  @override
  State<IntroPage> createState() => _IntroScanPageState(viewModel);
}

class _IntroScanPageState extends ViewState<IntroPage, IntroViewModel> {
  _IntroScanPageState(IntroViewModel viewModel) : super(viewModel);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.introPageTitle)),
      body: _buildBody(context, l10n),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    final viewModel = context.read<IntroProvider>().viewModel;
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Center(
              child: Text(viewModel.qrState == QrScanState.WAITING
                  ? l10n.introPageMessage
                  : "Scan neu")),
        ),
        Expanded(
          flex: 7,
          child: QRCameraView(
            (barcode) => viewModel.onScan(barcode.code ?? ""),
          ),
        ),
        if (EnvironmentConfig.isDev)
          SkipDebugButton(context.read<IntroProvider>().viewModel.onScan),
      ],
    );
  }
}
