import 'package:better_player/better_player.dart';
import 'package:carmanual/core/helper/player_config.dart';
import 'package:carmanual/core/navigation/app_navigation.dart';
import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:carmanual/core/navigation/navi.dart';
import 'package:carmanual/ui/screens/video/video_page.dart';
import 'package:carmanual/viewmodels/home_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends View<HomeViewModel> {
  static const String routeName = "/home";

  static AppRouteSpec poopToRoot() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.popUntilRoot,
      );

  static AppRouteSpec replaceWith() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.replaceWith,
      );

  HomePage(
    HomeViewModel viewModel, {
    Key? key,
  }) : super.model(viewModel, key: key);

  @override
  State<HomePage> createState() => _HomePageState(viewModel);
}

class _HomePageState extends ViewState<HomePage, HomeViewModel> {
  _HomePageState(HomeViewModel viewModel) : super(viewModel);

  @override
  Widget build(BuildContext context) {
    final title = AppLocalizations.of(context)!.homoPageTitle;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: HomeVideoPage.model(viewModel),
      bottomNavigationBar: AppNavigation(HomePage.routeName),
    );
  }
}

class HomeVideoPage extends View<HomeViewModel> {
  HomeVideoPage.model(HomeViewModel viewModel) : super.model(viewModel);

  @override
  State<HomeVideoPage> createState() => _HomeVideoPageState(viewModel);
}

class _HomeVideoPageState extends ViewState<HomeVideoPage, HomeViewModel> {
  _HomeVideoPageState(HomeViewModel viewModel) : super(viewModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
            child: StreamBuilder<BetterPlayerConfiguration>(
                stream: viewModel.watchSettings().map((settings) {
                  final vidSettings = settings.videos;
                  return playerConfigFromMap(vidSettings);
                }),
                builder: (context, snapshot) {
                  return viewModel.introVideo == null
                      ? VideoDownload()
                      : BetterPlayer.network(
                          viewModel.introVideo!.url,
                          betterPlayerConfiguration: snapshot.data,
                        );
                  ;
                })),
        Spacer(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Hier steht ein Willkommenstext, der den Käufer Willkommen heißt. Natürlich sagt dieser noch nix aus und ist nur ein Platzhalter. Aber freut mich trotzdem, dass Sie das Auto gekauft haben.",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
