// Future<void> swipeNoteToLeft(WidgetTester tester) async {
//   await tester.drag(find.byType(NoteDismissible), const Offset(-500.0, 0.0));
//   await tester.pumpAndSettle();
// }

import 'package:carmanual/ui/screens/intro/intro_page.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> scanOnIntroPage(WidgetTester tester, String scan,
    {bool settle = true}) async {
  final page = find.byType(IntroPage).evaluate().first.widget as IntroPage;
  page.viewModel.onScan(scan);
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
}
