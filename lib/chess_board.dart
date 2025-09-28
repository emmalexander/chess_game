import 'package:chess_game/components/piece.dart';
import 'package:chess_game/components/square.dart';
import 'package:chess_game/helper/helper_methods.dart';
import 'package:chess_game/utils/colors.dart';
import 'package:flutter/material.dart';

class ChessBoard extends StatefulWidget {
  const ChessBoard({super.key});

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  List<List<ChessPiece?>> _board = [];

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  void _initializeBoard() {
    List<List<ChessPiece?>> newBoard = List.generate(
      8,
      (index) => List.generate(8, (index) => null),
    );

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
  int _selectedRow = -1;
  int _selectedCol = -1;

  void _selectAPiece(int row, int col) {
    if (_board[row][col] != null) {
      setState(() {
        _selectedPiece = _board[row][col];
        _selectedRow = row;
        _selectedCol = col;
      });
      _calculateValidRawMoves();
    }
  }

  void _calculateValidRawMoves() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkShade,
      body: Column(
        children: [
          SizedBox(
            height: 500,
            child: GridView.builder(
              itemCount: 8 * 8,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
              ),
              itemBuilder: (context, index) {
                int row = index ~/ 8;
                int column = index % 8;
                bool isSelected;
                if (_selectedRow == row && _selectedCol == column) {
                  isSelected = true;
                } else {
                  isSelected = false;
                }
                return Square(
                  isWhite: isWhite(index),
                  piece: _board[row][column],
                  isSelected: isSelected,
                  onTap: () => _selectAPiece(row, column),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
