import 'package:flutter/material.dart';

enum GameType { infinite, legacy }

class GameSettings with ChangeNotifier {
  static late GameType _gameType;
  static late int _matrixSize;
  static late int _roundsToWin;

  static String player1Username = 'player1';
  static String player2Username = 'player2';
  static String player1Symbol = 'X';
  static String player2Symbol = 'O';

  GameSettings() {
    _gameType = GameType.legacy;
    _matrixSize = 3;
    _roundsToWin = 1;
  }

  bool get isInfinite => _gameType == GameType.infinite;

  int get matrixSize => _matrixSize;

  GameType get gameType => _gameType;

  int get roundsToWin => _roundsToWin;

  set roundsToWin(int numberOfRounds) {
    _roundsToWin = numberOfRounds;
    notifyListeners();
  }

  set matrixSize(int size) {
    _matrixSize = size;
    notifyListeners();
  }

  set gameType(GameType type) {
    _gameType = type;
    notifyListeners();
  }

  void switchGameType() {
    if (isInfinite) {
      gameType = GameType.legacy;
    } else {
      gameType = GameType.infinite;
    }
  }

  String getGameTypeAsString() {
    switch (gameType) {
      case GameType.infinite:
        {
          return 'Infinite';
        }
      case GameType.legacy:
        {
          return 'Legacy';
        }
    }
  }

  List<int> getMatrixSizes() {
    return [3, 4, 5, 6, 7, 8, 9];
  }

  List<int> getNumberOfWins() {
    return [1, 2, 3, 4, 5];
  }
}
