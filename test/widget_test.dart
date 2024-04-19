import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_exemple_game/screens/game/game_screen.dart';
import 'package:test_exemple_game/screens/play/play_screen.dart';
// play_screen.dart nomli faylni o'zgartiring

void main() {
  testWidgets('Play screen UI test', (WidgetTester tester) async {
    // Testni boshlash uchun PlayScreen widgetini yaratamiz
    await tester.pumpWidget(MaterialApp(home: PlayScreen()));

    // "4 Pics 1 Word" matnini topish
    expect(find.text('4 Pics 1 Word'), findsOneWidget);

    // "PLAY" tugmasini topish
    expect(find.text('PLAY'), findsOneWidget);

    // Tugma bosilganda yangi oynani ochishni sinab ko'ramiz
    await tester.tap(find.text('PLAY'));
    await tester.pumpAndSettle();

    // Yangi oyna ochilganligini va boshqa elementlarni topishni tekshirish
    expect(find.byType(GameScreen), findsOneWidget);
  });
}
