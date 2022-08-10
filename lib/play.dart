import 'package:flutter/material.dart';

enum Play { none, X, O }

extension PlayExtension on Play {
  String get value {
    switch (this) {
      case Play.O:
        return "O";
      case Play.X:
        return "X";
      default:
        return "";
    }
  }

  Color get fieldColor {
    switch (this) {
      case Play.O:
        return Colors.blue;
      case Play.X:
        return Colors.red;
      default:
        return Colors.white;
    }
  }

  Color get backgroundColor {
    final thisMove = this == Play.X ? Play.O : Play.X;

    return thisMove.fieldColor.withAlpha(150);
  }

  Play get nextPlay {
    return this == Play.X ? Play.O : Play.X;
  }

  String get winnerValue {
    switch (this) {
      case Play.O:
        return "⭕";
      case Play.X:
        return "❌";
      default:
        return tieValue;
    }
  }

  static String get tieValue {
    return "🛑";
  }
}
