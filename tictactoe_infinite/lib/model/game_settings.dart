import 'package:flutter/material.dart';

enum GameType {
  infinite,
  legacy
}

class GameSettings with ChangeNotifier {
  late GameType _gameType;
  late int _matrixSize;

  GameSettings() {
    _gameType = GameType.legacy;
    _matrixSize = 3;
  }

  bool get isInfinite => _gameType == GameType.infinite;

  int get matrixSize => _matrixSize;

  set matrixSize(int size) {
    _matrixSize = size;
    notifyListeners();
  }

  set gameType(GameType type){
    _gameType = type;
    notifyListeners();
  }

  void switchGameType() {
    if(isInfinite){
      gameType = GameType.legacy;
    } else {
      gameType = GameType.infinite;
    }
  }
}
