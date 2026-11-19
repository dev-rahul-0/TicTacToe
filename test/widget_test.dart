import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiktak/main.dart';

void main() {
  testWidgets('tapping an occupied square preserves the current turn',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(MyApp(prefs: prefs));

    final squares = find.descendant(
      of: find.byType(GridView),
      matching: find.byType(GestureDetector),
    );
    Future<void> tapSquare(int index) async {
      await tester.tap(squares.at(index));
      await tester.pump();
    }

    await tapSquare(0); // O moves.
    await tapSquare(0); // X taps O's occupied square.
    await tapSquare(1);
    expect(find.descendant(of: squares.at(0), matching: find.text('O')),
        findsOneWidget);
    expect(find.descendant(of: squares.at(1), matching: find.text('X')),
        findsOneWidget);

    await tapSquare(1); // O taps X's occupied square.
    await tapSquare(2);
    expect(find.descendant(of: squares.at(2), matching: find.text('O')),
        findsOneWidget);
  });
}
