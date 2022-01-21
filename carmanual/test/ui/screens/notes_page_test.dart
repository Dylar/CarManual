// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child ui.widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// void main() {
//   testWidgets('add note on AddNote-button tap', (WidgetTester tester) async {
//     await initNavigateToNotes(tester);
//
//     expect(find.byType(CarInfoListItem), findsNWidgets(0));
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.pumpAndSettle();
//     expect(find.byType(CarInfoListItem), findsNWidgets(1));
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.pumpAndSettle();
//     expect(find.byType(CarInfoListItem), findsNWidgets(2));
//   });
//
//   testWidgets('swipe note to delete', (WidgetTester tester) async {
//     await initNavigateToNotes(tester);
//
//     expect(find.byType(CarInfoListItem), findsNWidgets(0));
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.pumpAndSettle();
//     expect(find.byType(CarInfoListItem), findsNWidgets(1));
//
//     expect(find.byType(DismissDialog), findsNothing);
//     await swipeNoteToLeft(tester);
//
//     expect(find.byType(DismissDialog), findsOneWidget);
//     await tester.tap(find.text('Cancel'));
//     await tester.pumpAndSettle();
//
//     expect(find.byType(CarInfoListItem), findsNWidgets(1));
//     expect(find.byType(DismissDialog), findsNothing);
//
//     await swipeNoteToLeft(tester);
//     await tester.tap(find.text('Confirm'));
//     await tester.pumpAndSettle();
//     expect(find.byType(CarInfoListItem), findsNWidgets(0));
//   });
// }
