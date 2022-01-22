import 'package:carmanual/core/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // debugPaintSizeEnabled = true;

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(App.load());
  });
}
