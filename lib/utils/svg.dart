import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Utility class for SVG assets
class PieceSvg {
  /// Base path for SVG assets
  static const String _basePath = 'assets/svg/';

  /// Get an SVG asset as a SvgPicture widget
  /// Falls back to a Material Icon if the SVG asset is not found
  static Widget asset(
    String name, {
    bool isWhite = true,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
    Color? color,
    IconData fallbackIcon = Icons.image,
  }) {
    try {
      return SvgPicture.asset(
        '$_basePath$name-${isWhite ? 'w' : 'b'}.svg',
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        colorFilter: color != null
            ? ColorFilter.mode(color, BlendMode.srcIn)
            : null,
      );
    } catch (e) {
      // Return a fallback icon if SVG asset is not found
      return Icon(fallbackIcon, size: width ?? 24, color: color);
    }
  }
}

/// SVG asset paths for easy reference
class AppSvgAssets {
  // SVG file paths
  static String king(bool isWhite) {
    if (isWhite) {
      return 'king-w.svg';
    } else {
      return 'king-b.svg';
    }
  }

  static String bishop(bool isWhite) {
    if (isWhite) {
      return 'bishop-w.svg';
    } else {
      return 'bishop-b.svg';
    }
  }

  static String knight(bool isWhite) {
    if (isWhite) {
      return 'knight-w.svg';
    } else {
      return 'knight-b.svg';
    }
  }

  static String pawn(bool isWhite) {
    if (isWhite) {
      return 'pawn-w.svg';
    } else {
      return 'pawn-b.svg';
    }
  }

  static String queen(bool isWhite) {
    if (isWhite) {
      return 'queen-w.svg';
    } else {
      return 'queen-b.svg';
    }
  }

  static String rook(bool isWhite) {
    if (isWhite) {
      return 'rook-w.svg';
    } else {
      return 'rook-b.svg';
    }
  }
}

/// Example usage:
/// ```dart
/// AppSvg.asset(AppSvgAssets.logo, width: 24, height: 24, color: Colors.blue)
/// ```
