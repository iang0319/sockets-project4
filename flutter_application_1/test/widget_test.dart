// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Build workout button goes to workout creator screen',
      (tester) async {
    await tester
        .pumpWidget(const MaterialApp(home: HomePage(title: "Movement Pro")));

    expect(find.byKey(const Key('BButton')), findsNWidgets(1));

    await tester.tap(find.byKey(Key('BButton')));

    await tester.pump();
    await tester.pump();
    expect(find.byType(ToDoList), findsOneWidget);
  });

  testWidgets('Join workout button goes to the join workout screen',
      (tester) async {
    await tester
        .pumpWidget(const MaterialApp(home: HomePage(title: "Movement Pro")));

    expect(find.byKey(const Key('JButton')), findsNWidgets(1));

    await tester.tap(find.byKey(Key('JButton')));

    await tester.pump();
    await tester.pump();
    expect(find.byType(JoinPage), findsOneWidget);
  });

  testWidgets('There are 3 buttons on the join workout page', (tester) async {
    await tester
        .pumpWidget(const MaterialApp(home: HomePage(title: "Movement Pro")));

    expect(find.byKey(const Key('BButton')), findsNWidgets(1));

    await tester.tap(find.byKey(Key('JButton')));

    await tester.pump();
    await tester.pump();
    expect(find.byKey(const Key("Connection")), findsOneWidget);
    expect(find.byKey(const Key("Password")), findsOneWidget);
    expect(find.byKey(const Key("View Connections")), findsOneWidget);
  });
}
