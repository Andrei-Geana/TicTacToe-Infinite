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

  GameType get gameType => _gameType;

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

  String getGameTypeAsString() {
    switch(gameType){
      case GameType.infinite: {
        return 'INFINITE';
      }
      case GameType.legacy: {
        return 'LEGACY';
      }
    }
  }

  List<int> getMatrixSizes(){
    return [3, 4, 5, 6, 7, 8, 9];
  }
}
