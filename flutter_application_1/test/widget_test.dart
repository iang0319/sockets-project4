// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_application_1/workout_items.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:flutter_application_1/serializer.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  /*
  this text is for testing if sending messages 

  test('convert', () {
    
    UserStampedMessage msg = UserStampedMessage("This is a test", User("Gabriel Ferrer", "Professor", ));
    Map<String,dynamic> msgJson = msg.toJson();
    String msgStr = jsonEncode(msgJson);
    // Send it over a network, receive it, rebuild it.
    Map<String,dynamic> decodedMap = jsonDecode(msgStr);
    expect(msgJson, decodedMap);
    UserStampedMessage recovered = UserStampedMessage.fromJson(decodedMap);
    expect(recovered, msg);
  });

  */
}
