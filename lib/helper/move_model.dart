import 'package:chess_game/components/piece.dart';

class Move {
  final int startRow;
  final int startCol;
  final int endRow;
  final int endCol;
  final ChessPiece piece;
  final ChessPiece? capturedPiece;
  final bool isWhiteMove;

  Move({
    required this.startRow,
    required this.startCol,
    required this.endRow,
    required this.endCol,
    required this.piece,
    this.capturedPiece,
    required this.isWhiteMove,
  });

  Map<String, dynamic> toMap() {
    return {
      'startRow': startRow,
      'startCol': startCol,
      'endRow': endRow,
      'endCol': endCol,
      'pieceType': piece.type.toString(),
      'pieceIsWhite': piece.isWhite ? 1 : 0,
      'capturedPieceType': capturedPiece?.type.toString(),
      'capturedPieceIsWhite': capturedPiece?.isWhite == true ? 1 : 0,
      'isWhiteMove': isWhiteMove ? 1 : 0,
    };
  }

  static Move fromMap(Map<String, dynamic> map) {
    return Move(
      startRow: map['startRow'],
      startCol: map['startCol'],
      endRow: map['endRow'],
      endCol: map['endCol'],
      piece: ChessPiece(
        type: ChessPieceType.values.firstWhere(
          (e) => e.toString() == map['pieceType'],
        ),
        isWhite: map['pieceIsWhite'] == 1,
        imagePath: _getImagePath(
          ChessPieceType.values.firstWhere(
            (e) => e.toString() == map['pieceType'],
          ),
        ),
      ),
      capturedPiece: map['capturedPieceType'] != null
          ? ChessPiece(
              type: ChessPieceType.values.firstWhere(
                (e) => e.toString() == map['capturedPieceType'],
              ),
              isWhite: map['capturedPieceIsWhite'] == 1,
              imagePath: _getImagePath(
                ChessPieceType.values.firstWhere(
                  (e) => e.toString() == map['capturedPieceType'],
                ),
              ),
            )
          : null,
      isWhiteMove: map['isWhiteMove'] == 1,
    );
  }

  static String _getImagePath(ChessPieceType type) {
    switch (type) {
      case ChessPieceType.pawn:
        return 'pawn';
      case ChessPieceType.rook:
        return 'rook';
      case ChessPieceType.knight:
        return 'knight';
      case ChessPieceType.bishop:
        return 'bishop';
      case ChessPieceType.queen:
        return 'queen';
      case ChessPieceType.king:
        return 'king';
    }
  }
}
