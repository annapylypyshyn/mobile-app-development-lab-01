import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab_01/main.dart';

void main() {
  testWidgets('Login screen is displayed', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartHomeApp());

    expect(find.text('HomeFlow'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);

    expect(tester.takeException(), isNull);
  });

  testWidgets('Registration screen opens', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartHomeApp());

    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();

    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);

    expect(tester.takeException(), isNull);
  });

  testWidgets('Registration screen returns to login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SmartHomeApp());

    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('HomeFlow'), findsOneWidget);

    expect(tester.takeException(), isNull);
  });
}
