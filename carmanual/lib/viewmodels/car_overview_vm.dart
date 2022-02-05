import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:carmanual/models/car_info.dart';
import 'package:carmanual/service/car_info_service.dart';
import 'package:provider/provider.dart';

class CarOverViewModelProvider
    extends ChangeNotifierProvider<CarOverViewModel> {
  CarOverViewModelProvider(CarInfoService carInfoService)
      : super(create: (_) => CarOverVM(carInfoService));
}

abstract class CarOverViewModel extends ViewModel {
  Stream<List<CarInfo>> watchCars();
}

class CarOverVM extends CarOverViewModel {
  CarInfoService carInfoService;

  CarOverVM(this.carInfoService);

  @override
  Stream<List<CarInfo>> watchCars() {
    return carInfoService.carInfoDataSource.watchCarInfo();
  }
}
