import 'package:chess_game/components/dead_piece.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DeadPiece Widget', () {
    testWidgets('Renders the piece with opacity', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: DeadPiece(imagePath: 'pawn', isWhite: true)),
        ),
      );

      // Find the Opacity widget
      final opacityWidget = tester.widget<Opacity>(find.byType(Opacity));

      // Verify the opacity is set to 0.6
      expect(opacityWidget.opacity, 0.6);

      // Verify that the piece image is rendered
      expect(find.byType(Image), findsOneWidget);
    });
  });
}
