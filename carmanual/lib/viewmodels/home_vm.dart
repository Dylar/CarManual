import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeViewModelProvider extends ChangeNotifierProvider<HomeViewModel> {
  HomeViewModelProvider() : super(create: (_) => HomeVM());
}

abstract class HomeViewModel extends ViewModel {
  int get count;

  void incrementCounter();

  void dispose();
}

class HomeVM extends HomeViewModel {
  int _counter = 0;

  @override
  int get count => _counter;

  @override
  void incrementCounter() {
    _counter++;
    notifyListeners();
  }
}
