import 'package:chess_game/utils/svg.dart';
import 'package:flutter/material.dart';

class DeadPiece extends StatelessWidget {
  const DeadPiece({super.key, required this.imagePath, required this.isWhite});
  final String imagePath;
  final bool isWhite;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.6,
      child: PieceSvg.asset(imagePath, isWhite: isWhite),
    );
  }
}
