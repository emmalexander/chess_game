import 'package:chess_game/components/piece.dart';
import 'package:chess_game/notifier/chess_board_notifier.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChessBoardNotifier', () {
    late ChessBoardNotifier chessBoardNotifier;

    setUp(() {
      chessBoardNotifier = ChessBoardNotifier();
      chessBoardNotifier.initializeBoard();
    });

    test('Initial board setup is correct', () {
      expect(chessBoardNotifier.board.length, 8);
      for (var row in chessBoardNotifier.board) {
        expect(row.length, 8);
      }

      // Verify pawn positions
      for (var i = 0; i < 8; i++) {
        expect(chessBoardNotifier.board[1][i]?.type, ChessPieceType.pawn);
        expect(chessBoardNotifier.board[1][i]?.isWhite, false);
        expect(chessBoardNotifier.board[6][i]?.type, ChessPieceType.pawn);
        expect(chessBoardNotifier.board[6][i]?.isWhite, true);
      }

      // Verify rook positions
      expect(chessBoardNotifier.board[0][0]?.type, ChessPieceType.rook);
      expect(chessBoardNotifier.board[0][7]?.type, ChessPieceType.rook);
      expect(chessBoardNotifier.board[7][0]?.type, ChessPieceType.rook);
      expect(chessBoardNotifier.board[7][7]?.type, ChessPieceType.rook);
    });

    test('Select a piece', () {
      chessBoardNotifier.selectAPiece(6, 4); // Select white pawn
      expect(chessBoardNotifier.selectedPiece, isNotNull);
      expect(chessBoardNotifier.selectedRow, 6);
      expect(chessBoardNotifier.selectedCol, 4);
    });

    test('Move a piece', () {
      chessBoardNotifier.selectAPiece(6, 4); // Select white pawn
      chessBoardNotifier.selectAPiece(4, 4); // Move to a valid square

      expect(chessBoardNotifier.board[4][4], isNotNull);
      expect(chessBoardNotifier.board[4][4]?.type, ChessPieceType.pawn);
      expect(chessBoardNotifier.board[6][4], isNull);
    });

    test('Invalid move - select opponent\'s piece', () {
      // It's white's turn initially
      chessBoardNotifier.selectAPiece(1, 4); // Try to select black pawn
      expect(chessBoardNotifier.selectedPiece, isNull);
    });
  });
}
