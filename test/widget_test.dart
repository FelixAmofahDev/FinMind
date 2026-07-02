// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/material.dart';

import 'package:finmind/features/onboarding/presentation/pages/welcome_page.dart';

void main() {
  testWidgets('renders the welcome screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: WelcomePage()));
    await tester.pumpAndSettle();

    expect(find.textContaining('Know your'), findsOneWidget);
    expect(find.text('Create your shop account'), findsOneWidget);
  });
}
