import 'package:carmanual/core/navigation/app_navigation.dart';
import 'package:carmanual/core/navigation/app_route_spec.dart';
import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:carmanual/ui/screens/video/video_page.dart';
import 'package:carmanual/viewmodels/home_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends View<HomeViewModel> {
  HomePage(
    HomeViewModel viewModel, {
    Key? key,
    this.title,
  }) : super.model(viewModel);

  static const String routeName = "/home";

  static AppRouteSpec routeToRoot() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.popUntilRoot,
      );

  static AppRouteSpec popAndPush() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.popAndPushTo,
      );

  static AppRouteSpec replaceWith() => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.replaceWith,
      );

  final String? title;

  @override
  State<HomePage> createState() => _HomePageState(viewModel);
}

class _HomePageState extends ViewState<HomePage, HomeViewModel> {
  _HomePageState(HomeViewModel viewModel) : super(viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title!)),
      body: CounterPage(),
      floatingActionButton: HomeFloatingButton(),
      bottomNavigationBar: AppNavigation(
        HomePage.routeName,
        viewModel.navigateTo,
      ),
    );
  }
}

class HomeFloatingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      // onPressed: () => Navigator.of(context).pushNamed(NotesPage.routeName),
      onPressed: () => Navigator.of(context).pushNamed(VideoPage.routeName),
      tooltip: "Record meme",
      child: Icon(Icons.record_voice_over),
    );
  }
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'You have pushed the button this many times:',
          ),
          Text(
            '${context.watch<HomeViewModel>().count}',
            style: Theme.of(context).textTheme.headline4,
          ),
          ElevatedButton(
            onPressed: context.read<HomeViewModel>().incrementCounter,
            child: Text('Increment'),
          )
        ],
      ),
    );
  }
}
