import 'package:chess_game/components/piece.dart';
import 'package:chess_game/helper/helper_methods.dart';
import 'package:chess_game/utils/navigator_key.dart';
import 'package:flutter/material.dart';

class ChessBoardNotifier extends ChangeNotifier {
  List<List<ChessPiece?>> _board = [];
  List<List<ChessPiece?>> get board => _board;

  List<ChessPiece?> _whitePiecesTaken = [];
  List<ChessPiece?> get whitePiecesTaken => _whitePiecesTaken;

  List<ChessPiece?> _blackPiecesTaken = [];
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

  /// INITIALIZE THE PIECES
  void initializeBoard() {
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

  ChessPiece? _selectedPiece;
  ChessPiece? get selectedPiece => _selectedPiece;

  int _selectedRow = -1;
  int get selectedRow => _selectedRow;

  int _selectedCol = -1;
  int get selectedCol => _selectedCol;

  List<List<int>> _validMoves = [];
  List<List<int>> get validMoves => _validMoves;

  /// SELECT A PIECE
  void selectAPiece(int row, int col) {
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
    _validMoves = _calculateRealValidMoves(
      _selectedRow,
      _selectedCol,
      _selectedPiece,
      true,
    );
    notifyListeners();
  }

  /// CALCULATE THE MOVES
  List<List<int>> _calculateRawValidMoves(int row, int col, ChessPiece? piece) {
    List<List<int>> candidateMoves = [];

    if (piece == null) {
      return [];
    }

    int direction = piece.isWhite ? -1 : 1;

    switch (piece.type) {
      case ChessPieceType.pawn:
        // can move one box at a time if square is not occupied
        /// row + direction is the row of the next square above the pawn
        if (isInBoard(row + direction, col) &&
            _board[row + direction][col] == null) {
          candidateMoves.add([row + direction, col]);
        }

        // Can move two squares only from the starting point
        if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if (isInBoard(row + (2 * direction), col) &&
              _board[row + direction][col] == null &&
              _board[row + (2 * direction)][col] == null) {
            candidateMoves.add([row + (2 * direction), col]);
          }
        }
        // Can kill another piece diagonally
        // row + direction, col - 1 is for the left diagonal square
        if (isInBoard(row + direction, col - 1) &&
            _board[row + direction][col - 1] != null &&
            _board[row + direction][col - 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col - 1]);
        }

        // row + direction, col + 1 is for the right diagonal square
        if (isInBoard(row + direction, col + 1) &&
            _board[row + direction][col + 1] != null &&
            _board[row + direction][col + 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col + 1]);
        }
        break;
      case ChessPieceType.rook:
        //Can move horizontally and vertically
        var directions = [
          [1, 0], // down
          [-1, 0], // up
          [0, 1], // right
          [0, -1], // left
        ];

        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            // If the opponent's piece is in the new square
            if (_board[newRow][newCol] != null) {
              if (_board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]); // Kill
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }

        break;
      case ChessPieceType.knight:
        //All 8 L shaped moves
        var knightMoves = [
          [-2, -1], // up 2 left 1
          [-1, -2], // up 1 left 2
          [-2, 1], // up 2 right 1
          [-1, 2], // up 1 right 2
          [2, -1], // down 2 left 1
          [1, -2], // down 1 left 2
          [2, 1], // down 2 right 1
          [1, 2], // down 1 right 2
        ];

        for (var move in knightMoves) {
          var newRow = row + move[0];
          var newCol = col + move[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (_board[newRow][newCol] != null) {
            if (_board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]); // Kill
            }
            continue; // blocked
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;
      case ChessPieceType.bishop:
        //Can move diagonally
        var directions = [
          [-1, -1], // top left
          [-1, 1], // top right
          [1, -1], // bottom left
          [1, 1], // bottom right
        ];

        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            // If the opponent's piece is in the new square
            if (_board[newRow][newCol] != null) {
              if (_board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]); // Kill
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.king:
        // All 8 directions
        var directions = [
          [1, 0], // down
          [-1, 0], // up
          [0, 1], // right
          [0, -1], // left
          [-1, -1], // top left
          [-1, 1], // top right
          [1, -1], // bottom left
          [1, 1], // bottom right
        ];

        for (var move in directions) {
          var newRow = row + move[0];
          var newCol = col + move[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (_board[newRow][newCol] != null) {
            if (_board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]); // Kill
            }
            continue; // blocked
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;
      case ChessPieceType.queen:
        var directions = [
          [1, 0], // down
          [-1, 0], // up
          [0, 1], // right
          [0, -1], // left
          [-1, -1], // top left
          [-1, 1], // top right
          [1, -1], // bottom left
          [1, 1], // bottom right
        ];

        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            // If the opponent's piece is in the new square
            if (_board[newRow][newCol] != null) {
              if (_board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]); // Kill
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
    }
    return candidateMoves;
  }

  List<List<int>> _calculateRealValidMoves(
    int row,
    int col,
    ChessPiece? piece,
    bool checkSimulation,
  ) {
    List<List<int>> realValidMoves = [];
    List<List<int>> candidateMoves = _calculateRawValidMoves(row, col, piece);

    if (checkSimulation) {
      for (var move in candidateMoves) {
        var endRow = move[0];
        var endCol = move[1];

        // This will simulate the future move to see if it is safe
        if (_simulatedMoveIsSafe(piece!, row, col, endRow, endCol)) {
          realValidMoves.add(move);
        }
      }
    } else {
      realValidMoves = candidateMoves;
    }
    return realValidMoves;
  }

  bool _simulatedMoveIsSafe(
    ChessPiece piece,
    int startRow,
    int startCol,
    int endRow,
    int endCol,
  ) {
    //save current board state
    ChessPiece? originalDestinationPiece = _board[endRow][endCol];

    // if piece is king, save its position and update the new one
    List<int>? originalKingPosition;
    if (piece.type == ChessPieceType.king) {
      originalKingPosition = piece.isWhite
          ? _whiteKingPosition
          : _blackKingPosition;

      //update the king's position
      if (piece.isWhite) {
        _whiteKingPosition = [endRow, endCol];
      } else {
        _blackKingPosition = [endRow, endCol];
      }
    }

    // simulate the move
    _board[endRow][endCol] = piece;
    _board[startRow][startCol] = null;

    // check is king is under attack
    bool kingInCheck = _isKingInCheck(piece.isWhite);

    // restore board to original state
    _board[startRow][startCol] = piece;
    _board[endRow][endCol] = originalDestinationPiece;

    // if piece was the king restore the original position
    if (piece.type == ChessPieceType.king) {
      if (piece.isWhite) {
        _whiteKingPosition = originalKingPosition!;
      } else {
        _blackKingPosition = originalKingPosition!;
      }
    }

    // if king is in check, then it is not safe
    return !kingInCheck;
  }

  /// MOVE THE PIECE
  void _movePiece(int newRow, int newCol) {
    // if there is a piece there
    if (_board[newRow][newCol] != null) {
      // add the piece to either a whiteTaken or blackTaken
      var capturedPiece = _board[newRow][newCol];
      if (_board[newRow][newCol]!.isWhite) {
        _whitePiecesTaken.add(capturedPiece);
      } else {
        _blackPiecesTaken.add(capturedPiece);
      }
    }

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

    // check for checkmate
    print("Check for Checkmate");
    print("is CheckMate: ${_isCheckMate(!_isWhiteTurn)}");

    if (_isCheckMate(!_isWhiteTurn)) {
      //Show dialog box with checkmate message and play again button
      print("CHECKMATE!!!!");
      print("navigatorKey.currentContext: ${navigatorKey.currentContext}");
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

    // change turns
    _isWhiteTurn = !_isWhiteTurn;
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
    notifyListeners();
  }

  bool _isKingInCheck(bool isWhiteKing) {
    // Find the king's position
    List<int> kingPosition = isWhiteKing
        ? _whiteKingPosition
        : _blackKingPosition;

    // Loop through the whole chessboard and check if any piece can kill the king
    for (var row = 0; row < 8; row++) {
      for (var col = 0; col < 8; col++) {
        // Skip empty squares and pieces of the same color
        if (_board[row][col] == null ||
            _board[row][col]!.isWhite == isWhiteKing) {
          continue;
        }
        // if (_board[row][col] != null &&
        //     _board[row][col]!.isWhite != isWhiteKing) {
        var validMoves = _calculateRealValidMoves(
          row,
          col,
          _board[row][col],
          false,
        );
        if (validMoves.any(
          (element) =>
              element[0] == kingPosition[0] && element[1] == kingPosition[1],
        )) {
          return true;
        }
        // }
      }
    }
    return false;
  }

  bool _isCheckMate(bool isWhiteKing) {
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

        List<List<int>> pieceValidMoves = _calculateRealValidMoves(
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
