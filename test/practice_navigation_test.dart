import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hci_project/screens/dashboard_screen.dart';
import 'package:hci_project/screens/practice_screen.dart';
import 'package:hci_project/screens/sound_selection_screen.dart';

void main() {
  // Helper to load the app
  Widget createDashboard() {
    return const MaterialApp(
      home: DashboardScreen(),
    );
  }

  testWidgets('Navigate to Practice tab via Bottom Navigation', (WidgetTester tester) async {
    await tester.pumpWidget(createDashboard());

    // Verify initial state (Home)
    expect(find.text('Good Afternoon,'), findsOneWidget);

    // Tap Practice tab (index 1)
    // Note: We look for the text 'Practice' in the bottom nav
    await tester.tap(find.text('Practice').last); // .last because duplicate texts might exist or quick action card also has text
    await tester.pumpAndSettle();

    // Verify SoundSectionScreen is displayed
    expect(find.byType(SoundSelectionScreen), findsOneWidget);
    expect(find.text('Choose a sound to practice!'), findsOneWidget);
  });

  testWidgets('Navigate to Practice tab via Quick Action Card', (WidgetTester tester) async {
    await tester.pumpWidget(createDashboard());

    // Tap Practice card
    // The card has text 'Practice' and Icon Icons.mic
    // We can find the widget that contains both or just tap the text that is part of the card
    // Since 'Practice' appears in bottom nav too, let's find the one in the body (Quick Action Cards)
    
    // Finding by icon might be safer for the card
    await tester.tap(find.widgetWithText(GestureDetector, 'Practice').first);
    await tester.pumpAndSettle();

    // Verify SoundSectionScreen is displayed
    expect(find.byType(SoundSelectionScreen), findsOneWidget);
  });

  testWidgets('Select a sound and navigate to PracticeScreen', (WidgetTester tester) async {
    // Start at SoundSelectionScreen directly to test deeper
    await tester.pumpWidget(const MaterialApp(home: SoundSelectionScreen()));

    // Verify grid is showing 'S'
    expect(find.text('S'), findsOneWidget);

    // Tap 'S'
    await tester.tap(find.text('S'));
    await tester.pump(); // Start navigation
    await tester.pump(const Duration(seconds: 1)); // Wait for navigation animation

    // Verify PracticeScreen
    expect(find.byType(PracticeScreen), findsOneWidget);
    expect(find.text("Practicing 'S'"), findsOneWidget);
  });

  testWidgets('PracticeScreen Listen and Record interaction', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PracticeScreen(sound: 'S')));

    // Initial state
    expect(find.text('Tap Listen or Record'), findsOneWidget);

    // Tap Listen
    await tester.tap(find.text('Listen'));
    await tester.pump(); // Start animation
    expect(find.text('Listen carefully...'), findsOneWidget);
    
    // Setup for async wait
    await tester.pump(const Duration(seconds: 2)); // Wait for listen to finish
    await tester.pump();
    expect(find.text('Tap Listen or Record'), findsOneWidget);

    // Tap Record
    await tester.tap(find.text('Record'));
    await tester.pump();
    expect(find.text('Listening...'), findsOneWidget);

    // Wait for record to finish (3s) + feedback delay (0.5s)
    await tester.pump(const Duration(seconds: 4)); 
    await tester.pump();

    // Verify feedback is shown (one of the positive messages)
    // Since it's random, we just check that it's NOT the default text
    expect(find.text('Tap Listen or Record'), findsNothing);
    expect(find.text('Listening...'), findsNothing);
  });
}
