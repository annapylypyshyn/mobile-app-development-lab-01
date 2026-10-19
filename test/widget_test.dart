import 'package:flutter_test/flutter_test.dart';
import 'package:lab_01/main.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Counter starts at zero', (WidgetTester tester) async {
    await tester.pumpWidget(const CounterApp());

    expect(find.text('0'), findsOneWidget);
    expect(find.text('Інтерактивний лічильник'), findsOneWidget);
  });

  testWidgets('Counter increases by entered integer', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CounterApp());

    await tester.enterText(find.byType(TextField), '10');
    await tester.tap(find.text('Застосувати'));
    await tester.pump();

    expect(find.text('10'), findsOneWidget);
  });
}
