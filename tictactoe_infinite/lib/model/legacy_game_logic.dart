import 'dart:math';
import 'package:tictactoe_infinite/model/player.dart';

class GameLogic {
  late List<List<String?>> board;
  late Player player1, player2;
  late bool isFirstPlayersTurn;
  late int matrixSize;

  GameLogic(String player1Name, String player1Symbol, String player2Name,
      String player2Symbol, this.matrixSize) {
    initializePlayers(player1Name, player1Symbol, player2Name, player2Symbol);
  }

  void initializePlayers(String player1Name, String player1Symbol,
      String player2Name, String player2Symbol) {
    player1 = Player(player1Name, 0, player1Symbol);
    player2 = Player(player2Name, 0, player2Symbol);
  }

  void initializeBoard() {
    board = List.generate(
        matrixSize, (_) => List.generate(matrixSize, (_) => null));
  }

  void pickWhoMovesFirst() {
    isFirstPlayersTurn = Random().nextBool();
  }

  void resetBoard() {
    initializeBoard();
  }

  bool moveWon(int row, int column) {
    return columnFilled(row, column) ||
        rowFilled(row, column) ||
        mainDiagonalFilled(row, column) ||
        secondaryDiagonalFilled(row, column);
  }

  bool columnFilled(int row, int column) {
    for (int i = 0; i < board[0].length; ++i) {
      if (board[i][column] == null || board[i][column] != board[row][column]) {
        return false;
      }
    }
    return true;
  }

  bool rowFilled(int row, int column) {
    for (int i = 0; i < board[0].length; ++i) {
      if (board[row][i] == null || board[row][i] != board[row][column]) {
        return false;
      }
    }
    return true;
  }

  bool mainDiagonalFilled(int row, int column) {
    if (row != column) return false;
    for (int i = 0; i < board[0].length; ++i) {
      if (board[i][i] == null || board[i][i] != board[row][column]) {
        return false;
      }
    }
    return true;
  }

  bool secondaryDiagonalFilled(int row, int column) {
    if (row + column != board[0].length - 1) return false;
    for (int i = 0; i < board[0].length; ++i) {
      int currentColumn = i;
      int currentRow = board[0].length - 1 - i;
      if (board[currentRow][currentColumn] == null ||
          board[currentRow][currentColumn] != board[row][column]) {
        return false;
      }
    }
    return true;
  }

  bool boardIsFull() {
    for (int i = 0; i < board[0].length; ++i) {
      for (int j = 0; j < board[0].length; ++j) {
        if (board[i][j] == null) return false;
      }
    }
    return true;
  }

  String getSymbolForMove() {
    return isFirstPlayersTurn ? player1.symbol : player2.symbol;
  }

  void switchTurn() {
    isFirstPlayersTurn = !isFirstPlayersTurn;
  }

  void resetScores() {
    player1.numberOfWins = 0;
    player2.numberOfWins = 0;
  }
}
