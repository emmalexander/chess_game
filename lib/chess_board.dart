import 'package:chess_game/components/dead_piece.dart';
import 'package:chess_game/components/square.dart';
import 'package:chess_game/helper/helper_methods.dart';
import 'package:chess_game/notifier/chess_board_notifier.dart';
import 'package:chess_game/utils/colors.dart';
import 'package:flutter/material.dart';

class ChessBoardProvider extends InheritedWidget {
  final ChessBoardNotifier notifier;

  const ChessBoardProvider({
    super.key,
    required super.child,
    required this.notifier,
  });

  static ChessBoardNotifier of(BuildContext context) {
    final ChessBoardProvider? result = context
        .dependOnInheritedWidgetOfExactType<ChessBoardProvider>();
    assert(result != null, 'No ChessBoardProvider found in context');
    return result!.notifier;
  }

  @override
  bool updateShouldNotify(ChessBoardProvider oldWidget) =>
      notifier != oldWidget.notifier;
}

class ChessBoard extends StatefulWidget {
  const ChessBoard({super.key});

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  final _chessBoardNotifier = ChessBoardNotifier();

  @override
  void initState() {
    super.initState();
    _chessBoardNotifier.initializeBoard();
  }

  @override
  Widget build(BuildContext context) {
    return ChessBoardProvider(
      notifier: _chessBoardNotifier,
      child: Scaffold(
        backgroundColor: AppColors.darkShade,
        body: ListenableBuilder(
          listenable: _chessBoardNotifier,
          builder: (context, _) {
            return Column(
              children: [
                //White Captured Pieces
                Expanded(
                  child: GridView.builder(
                    itemCount: _chessBoardNotifier.whitePiecesTaken.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8,
                    ),
                    itemBuilder: (context, index) => DeadPiece(
                      imagePath:
                          _chessBoardNotifier
                              .whitePiecesTaken[index]
                              ?.imagePath ??
                          '',
                      isWhite:
                          _chessBoardNotifier
                              .whitePiecesTaken[index]
                              ?.isWhite ??
                          false,
                    ),
                  ),
                ),
                Text(_chessBoardNotifier.checkStatus ? "CHECK!" : ""),
                Expanded(
                  flex: 3,
                  child: GridView.builder(
                    itemCount: 8 * 8,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8,
                    ),
                    itemBuilder: (context, index) {
                      int row = index ~/ 8;
                      int column = index % 8;
                      bool isSelected =
                          _chessBoardNotifier.selectedRow == row &&
                          _chessBoardNotifier.selectedCol == column;

                      bool isValid = false;
                      for (var position in _chessBoardNotifier.validMoves) {
                        if (position[0] == row && position[1] == column) {
                          isValid = true;
                        }
                      }
                      return Square(
                        isWhite: isWhite(index),
                        piece: _chessBoardNotifier.board[row][column],
                        isSelected: isSelected,
                        isValidMove: isValid,
                        onTap: () =>
                            _chessBoardNotifier.selectAPiece(row, column),
                      );
                    },
                  ),
                ),
                //Black Captured Pieces
                Expanded(
                  child: GridView.builder(
                    itemCount: _chessBoardNotifier.blackPiecesTaken.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8,
                    ),
                    itemBuilder: (context, index) => DeadPiece(
                      imagePath:
                          _chessBoardNotifier
                              .blackPiecesTaken[index]
                              ?.imagePath ??
                          '',
                      isWhite:
                          _chessBoardNotifier
                              .blackPiecesTaken[index]
                              ?.isWhite ??
                          false,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
