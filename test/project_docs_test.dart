import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jkolaka/theme/app_theme.dart';
import 'package:jkolaka/feature/project/presentation/project_page.dart';

Future<void> pumpDocs(WidgetTester tester, double width) async {
  tester.view.physicalSize = Size(width, 800);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.runAsync(() async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.lightTheme, home: const ProjectPage()),
    );
    await Future<void>.delayed(const Duration(milliseconds: 150));
  });
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('desktop', (tester) async {
    await pumpDocs(tester, 1280);
    expect(find.text('Zoa Docs'), findsOneWidget);
    expect(find.text('On this page'), findsOneWidget);
    expect(find.text('GETTING STARTED'), findsOneWidget);
    await tester.drag(
      find.byType(SingleChildScrollView).at(1),
      const Offset(0, -400),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('mobile', (tester) async {
    await pumpDocs(tester, 390);
    expect(find.text('Zoa Docs'), findsOneWidget);
    expect(find.text('On this page'), findsNothing);
    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(0, -400),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
