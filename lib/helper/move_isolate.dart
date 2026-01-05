// This file provides a top-level function usable with Flutter's compute
// to filter candidate moves by simulating them and ensuring the king
// is not left in check. The function uses only primitive types (maps,
// lists, ints) so it can be sent to an isolate.

List<List<int>> _deserializeMoves(dynamic raw) {
  final out = <List<int>>[];
  if (raw == null) return out;
  for (var m in raw) {
    out.add([m[0] as int, m[1] as int]);
  }
  return out;
}

// board encoding: -1 = empty, else code = typeIndex + (isWhite ? 10 : 0)
bool _isInBoard(int r, int c) => r >= 0 && r < 8 && c >= 0 && c < 8;

// Determine if a given color's king is in check on the provided board.
bool _kingInCheck(
  List<List<int>> board,
  bool isWhiteKing,
  List<int> whiteKingPos,
  List<int> blackKingPos,
) {
  final kingPos = isWhiteKing ? whiteKingPos : blackKingPos;
  final kingRow = kingPos[0];
  final kingCol = kingPos[1];

  for (var r = 0; r < 8; r++) {
    for (var c = 0; c < 8; c++) {
      final code = board[r][c];
      if (code == -1) continue;
      final attackerIsWhite = code >= 10;
      if (attackerIsWhite == isWhiteKing) continue; // same color
      final typeIndex = code % 10;

      // generate raw attacks for attacker at (r,c)
      switch (typeIndex) {
        case 0: // king
          for (var dr = -1; dr <= 1; dr++) {
            for (var dc = -1; dc <= 1; dc++) {
              if (dr == 0 && dc == 0) continue;
              final nr = r + dr;
              final nc = c + dc;
              if (!_isInBoard(nr, nc)) continue;
              if (nr == kingRow && nc == kingCol) return true;
            }
          }
          break;
        case 1: // queen (use rook + bishop)
        case 4: // rook
        case 2: // bishop
          final directions = <List<int>>[];
          if (typeIndex == 4 || typeIndex == 1) {
            directions.addAll([
              [1, 0],
              [-1, 0],
              [0, 1],
              [0, -1],
            ]);
          }
          if (typeIndex == 2 || typeIndex == 1) {
            directions.addAll([
              [1, 1],
              [1, -1],
              [-1, 1],
              [-1, -1],
            ]);
          }
          for (var dir in directions) {
            var i = 1;
            while (true) {
              final nr = r + i * dir[0];
              final nc = c + i * dir[1];
              if (!_isInBoard(nr, nc)) break;
              if (nr == kingRow && nc == kingCol) return true;
              if (board[nr][nc] != -1) break;
              i++;
            }
          }
          break;
        case 3: // knight
          final moves = [
            [-2, -1],
            [-1, -2],
            [-2, 1],
            [-1, 2],
            [2, -1],
            [1, -2],
            [2, 1],
            [1, 2],
          ];
          for (var m in moves) {
            final nr = r + m[0];
            final nc = c + m[1];
            if (!_isInBoard(nr, nc)) continue;
            if (nr == kingRow && nc == kingCol) return true;
          }
          break;
        case 5: // pawn
          // pawns attack diagonally forward depending on color
          final dir = attackerIsWhite ? -1 : 1;
          final ar1 = r + dir;
          if (_isInBoard(ar1, c - 1) && ar1 == kingRow && c - 1 == kingCol)
            return true;
          if (_isInBoard(ar1, c + 1) && ar1 == kingRow && c + 1 == kingCol)
            return true;
          break;
        default:
      }
    }
  }
  return false;
}

// Top-level entry for compute. Arguments must be JSON-serializable.
// args:
//  - board: List<List<int>> encoded
//  - pieceType: int (type index)
//  - pieceIsWhite: bool
//  - startRow, startCol: ints
//  - candidateMoves: List<List<int>>
//  - whiteKingPos, blackKingPos: List<int>
List<List<int>> filterSafeMoves(Map<String, dynamic> args) {
  final boardRaw = args['board'] as List;
  final board = <List<int>>[];
  for (var row in boardRaw) {
    final r = <int>[];
    for (var cell in row) {
      r.add(cell as int);
    }
    board.add(r);
  }

  final int pieceType = args['pieceType'] as int;
  final bool pieceIsWhite = args['pieceIsWhite'] as bool;
  final int startRow = args['startRow'] as int;
  final int startCol = args['startCol'] as int;
  final candidateMoves = _deserializeMoves(args['candidateMoves']);
  final whiteKingPos = List<int>.from(args['whiteKingPos'] as List);
  final blackKingPos = List<int>.from(args['blackKingPos'] as List);

  final safe = <List<int>>[];

  for (var mv in candidateMoves) {
    final endRow = mv[0];
    final endCol = mv[1];

    // deep copy board for simulation
    final simBoard = List<List<int>>.generate(
      8,
      (i) => List<int>.from(board[i]),
    );

    // encode piece
    final code = (pieceIsWhite ? 10 : 0) + pieceType;

    // save original destination (not needed explicitly)

    // update king positions if needed
    final originalWhiteKing = List<int>.from(whiteKingPos);
    final originalBlackKing = List<int>.from(blackKingPos);

    if (pieceType == 0) {
      if (pieceIsWhite) {
        whiteKingPos[0] = endRow;
        whiteKingPos[1] = endCol;
      } else {
        blackKingPos[0] = endRow;
        blackKingPos[1] = endCol;
      }
    }

    // simulate move
    simBoard[endRow][endCol] = code;
    simBoard[startRow][startCol] = -1;

    // check king in check
    final kingInCheck = _kingInCheck(
      simBoard,
      pieceIsWhite,
      whiteKingPos,
      blackKingPos,
    );

    // restore king positions
    whiteKingPos[0] = originalWhiteKing[0];
    whiteKingPos[1] = originalWhiteKing[1];
    blackKingPos[0] = originalBlackKing[0];
    blackKingPos[1] = originalBlackKing[1];

    if (!kingInCheck) safe.add([endRow, endCol]);
  }

  return safe;
}
