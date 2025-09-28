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
  });
  final bool isWhite, isSelected;
  final ChessPiece? piece;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    Color? selectedColor;
    if (isSelected) {
      selectedColor = Colors.green;
    } else {
      selectedColor = isWhite ? AppColors.lightShade : AppColors.darkShade;
    }
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        curve: Curves.linear,
        duration: const Duration(milliseconds: 300),
        color: selectedColor,
        child: piece != null
            ? PieceSvg.asset(piece!.imagePath, isWhite: piece!.isWhite)
            : null,
      ),
    );
  }
}
