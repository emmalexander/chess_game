import 'package:chess_game/components/piece.dart';
import 'package:chess_game/utils/colors.dart';
import 'package:chess_game/utils/svg.dart';
import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  const Square({
    super.key,
    required this.isWhite,
    this.piece,
    required this.isSelected,
    this.onTap,
    required this.isValidMove,
  });
  final bool isWhite, isSelected, isValidMove;
  final ChessPiece? piece;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    Color? squareColor;
    if (isSelected) {
      squareColor = Colors.green;
    } else if (isValidMove) {
      squareColor = Colors.green[200];
    } else {
      squareColor = isWhite ? AppColors.lightShade : AppColors.darkShade;
    }
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        curve: Curves.linear,
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: squareColor,
          border: Border.all(
            color: Colors.black.withAlpha(40),
            style: BorderStyle.solid,
            width: 0.5,
          ),
        ),
        child: piece != null
            ? PieceSvg.asset(piece!.imagePath, isWhite: piece!.isWhite)
            : null,
      ),
    );
  }
}
