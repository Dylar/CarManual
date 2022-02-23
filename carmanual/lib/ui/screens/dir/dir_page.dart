import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:carmanual/core/navigation/navi.dart';
import 'package:carmanual/models/car_info.dart';
import 'package:carmanual/ui/screens/dir/dir_list_item.dart';
import 'package:carmanual/ui/widgets/loading_overlay.dart';
import 'package:carmanual/ui/widgets/scroll_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../viewmodels/dir_vm.dart';

class DirPage extends View<DirViewModel> {
  static const String routeName = "/dirPage";
  static const String ARG_CAR = "car";

  static AppRouteSpec pushIt(CarInfo carInfo) => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.pushTo,
        arguments: {ARG_CAR: carInfo},
      );

  DirPage.model(DirViewModel viewModel) : super.model(viewModel);

  @override
  State<DirPage> createState() => _DirPageState(viewModel);
}

class _DirPageState extends ViewState<DirPage, DirViewModel> {
  _DirPageState(DirViewModel viewModel) : super(viewModel);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(viewModel.title)),
      body: _buildBody(context, l10n),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    final dirs = viewModel.getDirs();
    if (dirs.isEmpty) {
      //TODO make anders
      return LoadingOverlay();
    }
    return ScrollListView<String>(
      items: dirs,
      buildItemWidget: buildItemWidget,
    );
  }

  Widget buildItemWidget(int index, String item) => GestureDetector(
        child: DirListItem(item),
        onTap: () => viewModel.selectDir(item),
      );
}
