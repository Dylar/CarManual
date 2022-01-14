import 'package:carmanual/models/car_info.dart';
import 'package:flutter/material.dart';

class CarInfoListItem extends StatelessWidget {
  const CarInfoListItem(this.carInfo);

  final CarInfo carInfo;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Auto:',
          ),
          Text(
            '${carInfo.name}',
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    );
  }
}
