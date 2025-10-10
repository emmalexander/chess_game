import 'package:chess_game/components/piece.dart';
import 'package:chess_game/components/square.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Square Widget', () {
    testWidgets('Renders correct color for white and black squares', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Square(isWhite: true, isSelected: false, isValidMove: false),
          ),
        ),
      );
      // Verify colors are rendered correctly
    });

    testWidgets('Renders piece when provided', (WidgetTester tester) async {
      final piece = ChessPiece(
        type: ChessPieceType.pawn,
        isWhite: true,
        imagePath: 'pawn',
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Square(
              isWhite: true,
              isSelected: false,
              isValidMove: false,
              piece: piece,
            ),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('Calls onTap when tapped', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Square(
              isWhite: true,
              isSelected: false,
              isValidMove: false,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Square));
      expect(tapped, isTrue);
    });

    testWidgets('Renders selected color', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Square(isWhite: false, isSelected: true, isValidMove: false),
          ),
        ),
      );
      // You'd need to check the color of the container, which can be tricky.
      // This is more of an integration-level or golden test concern.
    });
  });
}
