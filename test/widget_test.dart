import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jkolaka/main.dart';

void main() {
  testWidgets('Work page renders nav and work list', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('JOE KOLAKA'), findsOneWidget);
    expect(find.text('WORK'), findsOneWidget);

    expect(find.text('Lake Basin Development Authority'), findsOneWidget);
    expect(find.text('Zone01 Kisumu'), findsOneWidget);
  });

  testWidgets('Footer exposes the contact links', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView).first, const Offset(0, -2000));
    await tester.pumpAndSettle();

    for (final label in ['Linkedin', 'EMAIL', 'X', 'Github', 'Devto']) {
      expect(find.text(label), findsOneWidget);
    }
  });

  testWidgets('HACKATHONS navigates to the hackathon page', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('HACKATHONS'));
    await tester.pumpAndSettle();

    expect(
      find.text('Hackathons & silly little side quests.'),
      findsOneWidget,
    );
    expect(find.text('Greentech'), findsNWidgets(2));
  });
}