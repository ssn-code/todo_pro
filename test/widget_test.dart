// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_pro/main.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('shows empty state and validates task creation', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Nothing on your list yet'), findsOneWidget);

    await tester.tap(find.text('Add task').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add task').last);
    await tester.pumpAndSettle();
    expect(find.text('Enter a task name'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField),
      'Review the launch plan',
    );
    await tester.tap(find.text('Add task').last);
    await tester.pumpAndSettle();
    expect(find.text('Review the launch plan'), findsOneWidget);

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);
  });

  testWidgets('settings offers all theme modes', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();

    expect(find.byType(SegmentedButton<ThemeMode>), findsOneWidget);
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
    expect(find.text('System'), findsOneWidget);

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<SegmentedButton<ThemeMode>>(
            find.byType(SegmentedButton<ThemeMode>),
          )
          .selected,
      {ThemeMode.dark},
    );
    expect(
      (await SharedPreferences.getInstance()).getString('theme_mode'),
      'dark',
    );
  });
}
