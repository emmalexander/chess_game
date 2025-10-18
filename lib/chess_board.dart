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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _chessBoardNotifier.moveHistory.isEmpty
                          ? null
                          : _chessBoardNotifier.undoMove,
                      icon: const Icon(Icons.undo, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: _chessBoardNotifier.undoneMoves.isEmpty
                          ? null
                          : _chessBoardNotifier.redoMove,
                      icon: const Icon(Icons.redo, color: Colors.white),
                    ),
                  ],
                ),
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      GridView.builder(
                        itemCount: 8 * 8,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
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
                      // Positioned(
                      //   top: 0, // Adjust this value to position the text
                      //   //left: 20, // Adjust this value to position the text
                      //   child: ListView.builder(
                      //     shrinkWrap: true,
                      //     physics: const NeverScrollableScrollPhysics(),
                      //     padding: EdgeInsets.zero,
                      //     itemBuilder: (context, index) {
                      //       return Text(
                      //         columnLabels[index],
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 20,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       );
                      //     },
                      //     itemCount: 8,
                      //     scrollDirection: Axis.horizontal,
                      //   ),
                      // ),
                    ],
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
