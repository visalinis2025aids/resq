import 'package:flutter_test/flutter_test.dart';
import 'package:safebee/main.dart';

void main() {
  testWidgets(
    'SafeBee app test',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const SafeBeeApp(),
      );

      expect(find.byType(SafeBeeApp), findsOneWidget);
    },
  );
}