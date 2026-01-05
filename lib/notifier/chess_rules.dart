import 'package:chess_game/components/piece.dart';
import 'package:chess_game/helper/move_model.dart';

class ChessRules {
  /// Check if a position is within the board limits (0-7)
  static bool isInBoard(int row, int col) {
    return row >= 0 && row < 8 && col >= 0 && col < 8;
  }

  /// Calculate raw valid moves for a piece.
  /// [checkCastling] should be false when checking if a square is under attack
  /// (e.g. during check detection) to avoid infinite recursion.
  static List<List<int>> calculateRawValidMoves({
    required int row,
    required int col,
    required ChessPiece? piece,
    required List<List<ChessPiece?>> board,
    required List<Move> moveHistory,
    required List<int> whiteKingPosition,
    required List<int> blackKingPosition,
    bool checkCastling = true,
  }) {
    List<List<int>> candidateMoves = [];

    if (piece == null) {
      return [];
    }

    int direction = piece.isWhite ? -1 : 1;

    switch (piece.type) {
      case ChessPieceType.pawn:
        // can move one box at a time if square is not occupied
        if (isInBoard(row + direction, col) &&
            board[row + direction][col] == null) {
          candidateMoves.add([row + direction, col]);
        }

        // Can move two squares only from the starting point
        if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if (isInBoard(row + (2 * direction), col) &&
              board[row + direction][col] == null &&
              board[row + (2 * direction)][col] == null) {
            candidateMoves.add([row + (2 * direction), col]);
          }
        }
        // Can kill another piece diagonally
        if (isInBoard(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col - 1]);
        }

        if (isInBoard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col + 1]);
        }

        // En passant moves
        // We need the last move to check en passant.
        // Assuming moveHistory is ordered, last move is last element.
        if (moveHistory.isNotEmpty) {
          final lastMove = moveHistory.last;
          if (lastMove.piece.type == ChessPieceType.pawn &&
              lastMove.piece.isWhite != piece.isWhite &&
              (lastMove.startRow - lastMove.endRow).abs() == 2) {
            // Check if adjacent
            if (row == lastMove.endRow &&
                (col - 1 == lastMove.endCol || col + 1 == lastMove.endCol)) {
              candidateMoves.add([row + direction, lastMove.endCol]);
            }
          }
        }
        break;
      case ChessPieceType.rook:
        var directions = [
          [1, 0], [-1, 0], [0, 1], [0, -1]
        ];
        for (var d in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * d[0];
            var newCol = col + i * d[1];
            if (!isInBoard(newRow, newCol)) break;
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.knight:
        var moves = [
          [-2, -1], [-1, -2], [-2, 1], [-1, 2],
          [2, -1], [1, -2], [2, 1], [1, 2]
        ];
        for (var m in moves) {
          var newRow = row + m[0];
          var newCol = col + m[1];
          if (isInBoard(newRow, newCol)) {
            if (board[newRow][newCol] == null ||
                board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]);
            }
          }
        }
        break;
      case ChessPieceType.bishop:
        var directions = [
          [-1, -1], [-1, 1], [1, -1], [1, 1]
        ];
        for (var d in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * d[0];
            var newCol = col + i * d[1];
            if (!isInBoard(newRow, newCol)) break;
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.queen:
        var directions = [
          [1, 0], [-1, 0], [0, 1], [0, -1],
          [-1, -1], [-1, 1], [1, -1], [1, 1]
        ];
        for (var d in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * d[0];
            var newCol = col + i * d[1];
            if (!isInBoard(newRow, newCol)) break;
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.king:
        var directions = [
          [1, 0], [-1, 0], [0, 1], [0, -1],
          [-1, -1], [-1, 1], [1, -1], [1, 1]
        ];
        for (var m in directions) {
          var newRow = row + m[0];
          var newCol = col + m[1];
          if (isInBoard(newRow, newCol)) {
            if (board[newRow][newCol] == null ||
                board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]);
            }
          }
        }

        if (checkCastling) {
          try {
            final kingRow = row;
            // Helper to check if king has moved
            bool kingHasMoved() {
              return moveHistory.any((m) =>
                  m.piece.type == ChessPieceType.king &&
                  m.piece.isWhite == piece.isWhite);
            }

            // Helper to check if rook has moved
            bool rookHasMoved(int rRow, int rCol) {
              // We check if any move started at the rook's initial position
              // AND was made by a rook of the same color.
              // NOTE: This logic assumes the rook at rRow,rCol IS the original rook.
              // If it was captured and replaced or moved back, this check might fail to detect it properly.
              // However, strictly adhering to original logic:
              return moveHistory.any((m) =>
                  m.piece.type == ChessPieceType.rook &&
                  m.piece.isWhite == piece.isWhite &&
                  m.startRow == rRow &&
                  m.startCol == rCol);
            }

            if (!kingHasMoved() &&
                !isKingInCheck(
                    board: board,
                    isWhiteKing: piece.isWhite,
                    whiteKingPosition: whiteKingPosition,
                    blackKingPosition: blackKingPosition,
                    moveHistory: moveHistory)) {
              // Kingside
              if (isInBoard(kingRow, 7)) {
                final rook = board[kingRow][7];
                if (rook != null &&
                    rook.type == ChessPieceType.rook &&
                    rook.isWhite == piece.isWhite &&
                    !rookHasMoved(kingRow, 7)) {
                  if (board[kingRow][5] == null && board[kingRow][6] == null) {
                    if (simulatedMoveIsSafe(piece, row, col, kingRow, 5, board,
                            whiteKingPosition, blackKingPosition, moveHistory) &&
                        simulatedMoveIsSafe(piece, row, col, kingRow, 6, board,
                            whiteKingPosition, blackKingPosition, moveHistory)) {
                      candidateMoves.add([kingRow, 6]);
                    }
                  }
                }
              }
              // Queenside
              if (isInBoard(kingRow, 0)) {
                final rook = board[kingRow][0];
                if (rook != null &&
                    rook.type == ChessPieceType.rook &&
                    rook.isWhite == piece.isWhite &&
                    !rookHasMoved(kingRow, 0)) {
                  if (board[kingRow][1] == null &&
                      board[kingRow][2] == null &&
                      board[kingRow][3] == null) {
                    if (simulatedMoveIsSafe(piece, row, col, kingRow, 3, board,
                            whiteKingPosition, blackKingPosition, moveHistory) &&
                        simulatedMoveIsSafe(piece, row, col, kingRow, 2, board,
                            whiteKingPosition, blackKingPosition, moveHistory)) {
                      candidateMoves.add([kingRow, 2]);
                    }
                  }
                }
              }
            }
          } catch (e) {
            // Ignore implicit errors during castling check
          }
        }
        break;
    }
    return candidateMoves;
  }

  static bool simulatedMoveIsSafe(
    ChessPiece piece,
    int startRow,
    int startCol,
    int endRow,
    int endCol,
    List<List<ChessPiece?>> board,
    List<int> whiteKingPosition,
    List<int> blackKingPosition,
    List<Move> moveHistory,
  ) {
    // Save state
    ChessPiece? originalDestinationPiece = board[endRow][endCol];
    List<int>? originalKingPos;
    if (piece.type == ChessPieceType.king) {
      originalKingPos =
          piece.isWhite ? [...whiteKingPosition] : [...blackKingPosition];
      if (piece.isWhite) {
        whiteKingPosition[0] = endRow;
        whiteKingPosition[1] = endCol;
      } else {
        blackKingPosition[0] = endRow;
        blackKingPosition[1] = endCol;
      }
    }

    // Apply move
    board[endRow][endCol] = piece;
    board[startRow][startCol] = null;

    bool kingInCheck = isKingInCheck(
      board: board,
      isWhiteKing: piece.isWhite,
      whiteKingPosition: whiteKingPosition,
      blackKingPosition: blackKingPosition,
      moveHistory: moveHistory,
    );

    // Restore state
    board[startRow][startCol] = piece;
    board[endRow][endCol] = originalDestinationPiece;

    if (piece.type == ChessPieceType.king && originalKingPos != null) {
      if (piece.isWhite) {
        whiteKingPosition[0] = originalKingPos[0];
        whiteKingPosition[1] = originalKingPos[1];
      } else {
        blackKingPosition[0] = originalKingPos[0];
        blackKingPosition[1] = originalKingPos[1];
      }
    }

    return !kingInCheck;
  }

  static bool isKingInCheck({
    required List<List<ChessPiece?>> board,
    required bool isWhiteKing,
    required List<int> whiteKingPosition,
    required List<int> blackKingPosition,
    required List<Move> moveHistory,
  }) {
    List<int> kingPosition = isWhiteKing ? whiteKingPosition : blackKingPosition;

    for (var row = 0; row < 8; row++) {
      for (var col = 0; col < 8; col++) {
        if (board[row][col] == null || board[row][col]!.isWhite == isWhiteKing) {
          continue;
        }

        List<List<int>> validMoves = calculateRawValidMoves(
          row: row,
          col: col,
          piece: board[row][col],
          board: board,
          moveHistory: moveHistory,
          whiteKingPosition: whiteKingPosition,
          blackKingPosition: blackKingPosition,
          checkCastling: false, // CRITICAL FIX: Prevent recursion
        );

        if (validMoves.any((element) =>
            element[0] == kingPosition[0] && element[1] == kingPosition[1])) {
          return true;
        }
      }
    }
    return false;
  }
}
