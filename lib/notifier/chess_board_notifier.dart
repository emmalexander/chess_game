import 'package:chess_game/components/piece.dart';
import 'package:chess_game/helper/database_helper.dart';
import 'package:chess_game/helper/helper_methods.dart';
import 'package:chess_game/helper/move_model.dart';
import 'package:chess_game/utils/navigator_key.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chess_game/helper/move_isolate.dart' as move_isolate;
import 'package:chess_game/notifier/chess_rules.dart';

class ChessBoardNotifier extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Move> _moveHistory = [];
  List<Move> get moveHistory => _moveHistory;

  List<Move> _undoneMoves = [];
  List<Move> get undoneMoves => _undoneMoves;

  List<List<ChessPiece?>> _board = [];
  List<List<ChessPiece?>> get board => _board;

  final List<ChessPiece?> _whitePiecesTaken = [];
  List<ChessPiece?> get whitePiecesTaken => _whitePiecesTaken;

  final List<ChessPiece?> _blackPiecesTaken = [];
  List<ChessPiece?> get blackPiecesTaken => _blackPiecesTaken;

  bool _isWhiteTurn = false;
  bool get isWhiteTurn => _isWhiteTurn;

  // Keep track of the positions of each kings
  List<int> _whiteKingPosition = [7, 4];
  List<int> get whiteKingPosition => _whiteKingPosition;

  List<int> _blackKingPosition = [0, 4];
  List<int> get blackKingPosition => _blackKingPosition;

  bool _checkStatus = false;
  bool get checkStatus => _checkStatus;

  // Track last moved piece for en passant
  ChessPiece? _lastMovedPiece;
  ChessPiece? get lastMovedPiece => _lastMovedPiece;

  List<int>? _lastMoveStart;
  List<int>? _lastMoveEnd;

  /// INITIALIZE THE PIECES
  void initializeBoard() {
    _loadMoves();

    List<List<ChessPiece?>> newBoard = List.generate(
      8,
      (index) => List.generate(8, (index) => null),
    );

    // //Add random piece
    // newBoard[3][3] = ChessPiece(
    //   type: ChessPieceType.bishop,
    //   isWhite: false,
    //   imagePath: 'bishop',
    // );

    // Add pawns
    for (var i = 0; i < 8; i++) {
      newBoard[1][i] = ChessPiece(
        type: ChessPieceType.pawn,
        isWhite: false,
        imagePath: 'pawn',
      );

      newBoard[6][i] = ChessPiece(
        type: ChessPieceType.pawn,
        isWhite: true,
        imagePath: 'pawn',
      );
    }

    // Add Rooks
    newBoard[0][0] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: 'rook',
    );
    newBoard[0][7] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: 'rook',
    );

    newBoard[7][0] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: 'rook',
    );
    newBoard[7][7] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: 'rook',
    );

    // Add Knights
    newBoard[0][1] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: false,
      imagePath: 'knight',
    );
    newBoard[0][6] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: false,
      imagePath: 'knight',
    );

    newBoard[7][1] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: true,
      imagePath: 'knight',
    );
    newBoard[7][6] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: true,
      imagePath: 'knight',
    );

    // Add Bishops
    newBoard[0][2] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: false,
      imagePath: 'bishop',
    );
    newBoard[0][5] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: false,
      imagePath: 'bishop',
    );

    newBoard[7][2] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: true,
      imagePath: 'bishop',
    );
    newBoard[7][5] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: true,
      imagePath: 'bishop',
    );

    // Add Queens
    newBoard[0][3] = ChessPiece(
      type: ChessPieceType.queen,
      isWhite: false,
      imagePath: 'queen',
    );

    newBoard[7][3] = ChessPiece(
      type: ChessPieceType.queen,
      isWhite: true,
      imagePath: 'queen',
    );

    // Add Kings
    newBoard[0][4] = ChessPiece(
      type: ChessPieceType.king,
      isWhite: false,
      imagePath: 'king',
    );

    newBoard[7][4] = ChessPiece(
      type: ChessPieceType.king,
      isWhite: true,
      imagePath: 'king',
    );

    _board = newBoard;
  }

  Future<void> _loadMoves() async {
    await _dbHelper.clearMoves();
  }

  ChessPiece? _selectedPiece;
  ChessPiece? get selectedPiece => _selectedPiece;

  int _selectedRow = -1;
  int get selectedRow => _selectedRow;

  int _selectedCol = -1;
  int get selectedCol => _selectedCol;

  List<List<int>> _validMoves = [];
  List<List<int>> get validMoves => _validMoves;

  /// SELECT A PIECE
  Future<void> selectAPiece(int row, int col) async {
    // check if the selected piece is being selected again or a different piece
    if (_validMoves.isNotEmpty &&
        _board[row][col] == _selectedPiece &&
        _board[row][col] != null) {
      //print(' Clearing selection');
      _validMoves = [];
      _selectedCol = -1;
      _selectedRow = -1;
      _selectedPiece = null;
      notifyListeners();
      return;
    }
    // No piece has been selected yet, this is the their first selection
    if (_board[row][col] != null && _selectedPiece == null) {
      if (_board[row][col]!.isWhite != _isWhiteTurn) {
        _selectedPiece = _board[row][col];
        _selectedRow = row;
        _selectedCol = col;
      }
    }
    // If there is a piece selected and the user wants to select another of their pieces
    else if (_selectedPiece != null &&
        _board[row][col] != null &&
        _board[row][col]!.isWhite == _selectedPiece!.isWhite) {
      _selectedPiece = _board[row][col];
      _selectedRow = row;
      _selectedCol = col;
    }
    // if there is a piece selected and the user taps on a square that is a valid move, move there
    else if (_selectedPiece != null &&
        _validMoves.any((element) => element[0] == row && element[1] == col)) {
      _movePiece(row, col);
    }
    // Use the isolate-backed move filtering for potentially expensive safety checks
    if (_selectedPiece != null) {
      _validMoves = await _calculateRealValidMovesAsync(
        _selectedRow,
        _selectedCol,
        _selectedPiece,
        true,
      );
    } else {
      _validMoves = [];
    }
    notifyListeners();
  }

  // Encode the board into a serializable List<List<int>> for isolates.
  // Representation: -1 = empty, else code = typeIndex + (isWhite ? 10 : 0)
  List<List<int>> _encodeBoardForIsolate() {
    final out = List<List<int>>.generate(8, (_) => List<int>.filled(8, -1));
    for (var r = 0; r < 8; r++) {
      for (var c = 0; c < 8; c++) {
        final piece = _board[r][c];
        if (piece == null) {
          out[r][c] = -1;
          continue;
        }
        final typeIndex = (() {
          switch (piece.type) {
            case ChessPieceType.king:
              return 0;
            case ChessPieceType.queen:
              return 1;
            case ChessPieceType.pawn:
              return 5;
            case ChessPieceType.knight:
              return 3;
            case ChessPieceType.bishop:
              return 2;
            case ChessPieceType.rook:
              return 4;
          }
        })();
        out[r][c] = (piece.isWhite ? 10 : 0) + typeIndex;
      }
    }
    return out;
  }

  Future<List<List<int>>> _calculateRealValidMovesAsync(
    int row,
    int col,
    ChessPiece? piece,
    bool checkSimulation,
  ) async {
    if (piece == null) return [];

    final candidateMoves = ChessRules.calculateRawValidMoves(
      row: row,
      col: col,
      piece: piece,
      board: _board,
      moveHistory: _moveHistory,
      whiteKingPosition: _whiteKingPosition,
      blackKingPosition: _blackKingPosition,
      checkCastling: true,
    );

    if (!checkSimulation) return candidateMoves;

    // Prepare args for isolate
    final args = {
      'board': _encodeBoardForIsolate(),
      'pieceType': (() {
        switch (piece.type) {
          case ChessPieceType.king:
            return 0;
          case ChessPieceType.queen:
            return 1;
          case ChessPieceType.pawn:
            return 5;
          case ChessPieceType.knight:
            return 3;
          case ChessPieceType.bishop:
            return 2;
          case ChessPieceType.rook:
            return 4;
        }
      })(),
      'pieceIsWhite': piece.isWhite,
      'startRow': row,
      'startCol': col,
      'candidateMoves': candidateMoves,
      'whiteKingPos': _whiteKingPosition,
      'blackKingPos': _blackKingPosition,
    };

    // Call the isolate filter
    final safe = await compute(move_isolate.filterSafeMoves, args);
    return safe;
  }

  List<List<int>> _calculateRealValidMoves(
    int row,
    int col,
    ChessPiece? piece,
    bool checkSimulation,
  ) {
    List<List<int>> candidateMoves = ChessRules.calculateRawValidMoves(
      row: row,
      col: col,
      piece: piece,
      board: _board,
      moveHistory: _moveHistory,
      whiteKingPosition: _whiteKingPosition,
      blackKingPosition: _blackKingPosition,
      checkCastling: true,
    );

    if (checkSimulation) {
      List<List<int>> realValidMoves = [];
      for (var move in candidateMoves) {
        if (ChessRules.simulatedMoveIsSafe(
          piece!, row, col, move[0], move[1],
          _board, _whiteKingPosition, _blackKingPosition, _moveHistory,
        )) {
          realValidMoves.add(move);
        }
      }
      return realValidMoves;
    } else {
      return candidateMoves;
    }
  }

  /// MOVE THE PIECE
  void _movePiece(int newRow, int newCol) {
    // Store the start position for last move tracking
    _lastMoveStart = [_selectedRow, _selectedCol];
    _lastMoveEnd = [newRow, newCol];
    _lastMovedPiece = _selectedPiece;

    ChessPiece? capturedPiece;

    // Check for en passant capture
    if (_selectedPiece!.type == ChessPieceType.pawn &&
        _board[newRow][newCol] == null &&
        newCol != _selectedCol) {
      // This is a diagonal move to an empty square, must be en passant
      var capturedP = _board[_selectedRow][newCol];
      if (capturedP != null) {
        if (capturedP.isWhite) {
          _whitePiecesTaken.add(capturedP);
        } else {
          _blackPiecesTaken.add(capturedP);
        }
        _board[_selectedRow][newCol] = null; // Remove the captured pawn
        capturedPiece = capturedP;
      }
    }
    // Regular capture
    else if (_board[newRow][newCol] != null) {
      // add the piece to either a whiteTaken or blackTaken
      capturedPiece = _board[newRow][newCol];
      if (_board[newRow][newCol]!.isWhite) {
        _whitePiecesTaken.add(capturedPiece!);
      } else {
        _blackPiecesTaken.add(capturedPiece!);
      }
    }

    final move = Move(
      startRow: _selectedRow,
      startCol: _selectedCol,
      endRow: newRow,
      endCol: newCol,
      piece: _selectedPiece!,
      capturedPiece: capturedPiece,
      isWhiteMove: _isWhiteTurn,
    );

    _moveHistory.add(move);
    // Fire-and-forget DB write; catch/log errors to avoid crashing the UI
    // schedule DB write without awaiting to avoid blocking
    _dbHelper.insertMove(move.toMap()).catchError((e) {});
    _undoneMoves.clear();

    // Check if the piece being moved is a king
    if (_selectedPiece!.type == ChessPieceType.king) {
      // Update the king's position
      if (_selectedPiece!.isWhite) {
        _whiteKingPosition = [newRow, newCol];
      } else {
        _blackKingPosition = [newRow, newCol];
      }
    }

    // move the piece and clear the old spot
    // Handle castling: if king moves two columns, move the rook accordingly
    if (_selectedPiece!.type == ChessPieceType.king &&
        (_selectedCol - newCol).abs() == 2) {
      // Kingside or queenside
      if (newCol == 6) {
        // Kingside: rook moves from col 7 to col 5
        final rook = _board[newRow][7];
        _board[newRow][5] = rook;
        _board[newRow][7] = null;
      } else if (newCol == 2) {
        // Queenside: rook moves from col 0 to col 3
        final rook = _board[newRow][0];
        _board[newRow][3] = rook;
        _board[newRow][0] = null;
      }
    }

    _board[newRow][newCol] = _selectedPiece;
    _board[_selectedRow][_selectedCol] = null;

    // update Check status
    if (_isKingInCheck(_isWhiteTurn)) {
      _checkStatus = true;
    } else {
      _checkStatus = false;
    }

    // clear selection
    _selectedPiece = null;
    _selectedRow = -1;
    _selectedCol = -1;
    _validMoves = [];

    // check for checkmate asynchronously to avoid blocking the UI
    _isCheckMateAsync(_isWhiteTurn).then((isMate) {
      if (isMate) {
        //Show dialog box with checkmate message and play again button
        showDialog(
          context: navigatorKey.currentContext!,
          builder: (context) => AlertDialog.adaptive(
            title: const Text("CHECK MATE!"),

            actions: [
              //reset the game and play again
              TextButton(
                onPressed: () => _resetGame(),
                child: const Text("PLAY AGAIN"),
              ),
            ],
          ),
        );
      }
    });

    // change turns
    _isWhiteTurn = !_isWhiteTurn;
    notifyListeners();
  }

  void undoMove() {
    if (_moveHistory.isEmpty) return;

    final lastMove = _moveHistory.removeLast();
    _undoneMoves.add(lastMove);
    // schedule DB delete without awaiting to avoid blocking
    _dbHelper.deleteLastMove().catchError((e) {});

    _board[lastMove.startRow][lastMove.startCol] = lastMove.piece;
    _board[lastMove.endRow][lastMove.endCol] = lastMove.capturedPiece;

    if (lastMove.capturedPiece != null) {
      if (lastMove.capturedPiece!.isWhite) {
        _whitePiecesTaken.remove(lastMove.capturedPiece);
      } else {
        _blackPiecesTaken.remove(lastMove.capturedPiece);
      }
    }

    if (lastMove.piece.type == ChessPieceType.king) {
      if (lastMove.piece.isWhite) {
        _whiteKingPosition = [lastMove.startRow, lastMove.startCol];
      } else {
        _blackKingPosition = [lastMove.startRow, lastMove.startCol];
      }
    }

    // If the undone move was a castling (king moved two columns), move the rook back
    if (lastMove.piece.type == ChessPieceType.king &&
        (lastMove.startCol - lastMove.endCol).abs() == 2) {
      final kingRow = lastMove.startRow;
      if (lastMove.endCol == 6) {
        // Kingside: rook was at 5, move it back to 7
        final rook = _board[kingRow][5];
        _board[kingRow][7] = rook;
        _board[kingRow][5] = null;
      } else if (lastMove.endCol == 2) {
        // Queenside: rook was at 3, move it back to 0
        final rook = _board[kingRow][3];
        _board[kingRow][0] = rook;
        _board[kingRow][3] = null;
      }
    }

    _isWhiteTurn = !_isWhiteTurn;
    _checkStatus = _isKingInCheck(!_isWhiteTurn);
    notifyListeners();
  }

  void redoMove() {
    if (_undoneMoves.isEmpty) return;

    final move = _undoneMoves.removeLast();
    _moveHistory.add(move);
    _dbHelper.insertMove(move.toMap());

    _board[move.endRow][move.endCol] = move.piece;
    _board[move.startRow][move.startCol] = null;

    if (move.capturedPiece != null) {
      if (move.capturedPiece!.isWhite) {
        _whitePiecesTaken.add(move.capturedPiece!);
      } else {
        _blackPiecesTaken.add(move.capturedPiece!);
      }
    }

    if (move.piece.type == ChessPieceType.king) {
      if (move.piece.isWhite) {
        _whiteKingPosition = [move.endRow, move.endCol];
      } else {
        _blackKingPosition = [move.endRow, move.endCol];
      }
    }

    // If this move is castling (king moved two columns), move the rook accordingly
    if (move.piece.type == ChessPieceType.king &&
        (move.startCol - move.endCol).abs() == 2) {
      final kingRow = move.endRow;
      if (move.endCol == 6) {
        // Kingside: move rook from 7 to 5
        final rook = _board[kingRow][7];
        _board[kingRow][5] = rook;
        _board[kingRow][7] = null;
      } else if (move.endCol == 2) {
        // Queenside: move rook from 0 to 3
        final rook = _board[kingRow][0];
        _board[kingRow][3] = rook;
        _board[kingRow][0] = null;
      }
    }

    _isWhiteTurn = !_isWhiteTurn;
    _checkStatus = _isKingInCheck(!_isWhiteTurn);
    notifyListeners();
  }

  void _resetGame() {
    Navigator.pop(navigatorKey.currentContext!);
    initializeBoard();
    _checkStatus = false;
    _whitePiecesTaken.clear();
    _blackPiecesTaken.clear();
    _blackKingPosition = [0, 4];
    _whiteKingPosition = [7, 4];
    _isWhiteTurn = true;
    _moveHistory.clear();
    _undoneMoves.clear();
    _dbHelper.clearMoves();
    notifyListeners();
  }

  bool _isKingInCheck(bool isWhiteKing) {
    return ChessRules.isKingInCheck(
      board: _board,
      isWhiteKing: isWhiteKing,
      whiteKingPosition: _whiteKingPosition,
      blackKingPosition: _blackKingPosition,
      moveHistory: _moveHistory,
    );
  }

  Future<bool> _isCheckMateAsync(bool isWhiteKing) async {
    // if the king is not in check, then it is not checkmate
    if (!_isKingInCheck(isWhiteKing)) {
      return false;
    }

    // if there is at least one legal move for the player's piece, then it is not checkmate
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        // skip empty boxes and the opponents pieces also
        if (_board[row][col] == null ||
            _board[row][col]!.isWhite != isWhiteKing) {
          continue;
        }

        // Use the isolate-backed async move generator for expensive safety checks
        final pieceValidMoves = await _calculateRealValidMovesAsync(
          row,
          col,
          _board[row][col],
          true,
        );

        // if this piece has any valid moves, then it is not checkmate
        if (pieceValidMoves.isNotEmpty) {
          return false;
        }
      }
    }

    // if none of the above conditions are met, then there are no valid moves to make
    // its checkmate
    return true;
  }
}
