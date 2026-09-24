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
}