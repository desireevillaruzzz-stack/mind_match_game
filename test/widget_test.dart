import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Basic widget smoke tests', () {
    testWidgets('MaterialApp builds successfully', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('Mind Match Test'),
            ),
          ),
        ),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Mind Match Test'), findsOneWidget);
    });

    testWidgets('Text widget is displayed', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Widget Test Running'),
          ),
        ),
      );

      expect(find.text('Widget Test Running'), findsOneWidget);
    });
  });
}
