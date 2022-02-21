import 'package:carmanual/ui/screens/home/home_page.dart';
import 'package:carmanual/ui/screens/intro/intro_page.dart';
import 'package:carmanual/ui/widgets/qr_camera_view.dart';
import 'package:carmanual/ui/widgets/video_widget.dart';
import 'package:flutter_test/flutter_test.dart';

void checkIntroPage() {
  expect(find.byType(IntroPage), findsOneWidget);
  expect(find.byType(QRCameraView), findsOneWidget);
}

void checkHomePage() {
  expect(find.byType(HomePage), findsOneWidget);
  expect(find.byType(VideoWidget), findsOneWidget);
}

void checkNavigationBar() {
  // naviBarData
}
