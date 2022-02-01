import 'package:carmanual/core/app.dart';
import 'package:carmanual/ui/screens/video_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  // debugPaintSizeEnabled = true;

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) async {
    VIDEO_SETTINGS["showControlsOnInitialize"] = false;
    VIDEO_SETTINGS["showOptions"] = false;
    VIDEO_SETTINGS["showControls"] = true;
    VIDEO_SETTINGS["autoPlay"] = true;
    VIDEO_SETTINGS["looping"] = false;
    await dotenv.load(fileName: ".env");
    runApp(App.load());
  });
}
