import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe_infinite/model/game_settings.dart';
import 'package:tictactoe_infinite/model/player.dart';

class GamePage extends StatefulWidget {
  final String player1Name, player2Name;
  const GamePage(
      {super.key, required this.player1Name, required this.player2Name});

  @override
  State<StatefulWidget> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late List<List<String?>> board;
  late Player player1, player2;
  late bool isFirstPlayersTurn;

  late double cellHeight, cellWidth, cellMarkSize;

  @override
  void initState() {
    super.initState();
    initializePlayers();
    initializeBoard();
    pickWhoMovesFirst();
    initializeCellSizes();
  }

  void initializeCellSizes() {
    switch (context.read<GameSettings>().matrixSize) {
      case 3:
        {
          cellHeight = 80;
          cellWidth = 80;
          cellMarkSize = 50;
        }
      case 4:
        {
          cellHeight = 60;
          cellWidth = 60;
          cellMarkSize = 40;
        }
      case 5:
        {
          cellHeight = 50;
          cellWidth = 50;
          cellMarkSize = 35;
        }
      default:
        {
          cellHeight = 30;
          cellWidth = 30;
          cellMarkSize = 20;
        }
    }
  }

  void pickWhoMovesFirst() {
    isFirstPlayersTurn = Random().nextBool();
  }

  void initializePlayers() {
    player1 = Player(widget.player1Name, 0, 'X');
    player2 = Player(widget.player2Name, 0, 'O');
  }

  void initializeBoard() {
    final matrixSize = context.read<GameSettings>().matrixSize;
    board = List.generate(
        matrixSize, (_) => List.generate(matrixSize, (_) => null));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<GameSettings>(context).getGameTypeAsString(),
            style: const TextStyle(
              fontSize: 15,
            )),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          player1.symbol,
                          style: const TextStyle(
                            fontSize: 60,
                          ),
                        ),
                        Text(
                          player1.username,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          player2.symbol,
                          style: const TextStyle(
                            fontSize: 60,
                          ),
                        ),
                        Text(
                          player2.username,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(player1.numberOfWins.toString()),
                    Text(player2.numberOfWins.toString())
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                    '${isFirstPlayersTurn ? player1.username : player2.username} now moves.')
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 55,
                ),
                buildBoard(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pickWhoMovesFirst();
          resetBoard();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget buildBoard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        context.read<GameSettings>().matrixSize,
        (row) => Column(
          children: [
            buildRow(row),
            if (row < context.read<GameSettings>().matrixSize - 1)
              const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget buildRow(int row) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        context.read<GameSettings>().matrixSize,
        (col) => Row(
          children: [
            buildCell(row, col),
            if (col < context.read<GameSettings>().matrixSize - 1)
              const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }

  Widget buildCell(int row, int col) {
    final cellValue = board[row][col];
    return GestureDetector(
      onTap: () => onCellTap(row, col),
      child: Container(
        width: cellWidth,
        height: cellHeight,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        child: Text(
          cellValue ?? '',
          style: TextStyle(
            fontSize: cellMarkSize,
          ),
        ),
      ),
    );
  }

  void onCellTap(int row, int col) {
    if (board[row][col] == null) {
      setState(() {
        board[row][col] = getSymbolForMove();
        if (moveWon(row, col)) {
          if (isFirstPlayersTurn) {
            player1.numberOfWins++;
          } else {
            player2.numberOfWins++;
          }
          showResultDialog();
          return;
        } else if (boardIsFull()) {
          showStalemate();
          return;
        }
        switchTurn();
      });
    }
  }

  void finishGame() {
    resetBoard();
    pickWhoMovesFirst();
  }

  void resetBoard() {
    setState(() {
      initializeBoard();
    });
  }

  bool moveWon(int row, int column) {
    return columnFilled(row, column) ||
        rowFilled(row, column) ||
        mainDiagonalFilled(row, column) ||
        secondaryDiagonalFilled(row, column);
  }

  bool columnFilled(int row, int column) {
    for (int i = 0; i < board[0].length; ++i) {
      if (board[i][column] == null) {
        return false;
      }
      if (board[i][column] != board[row][column]) {
        return false;
      }
    }

    return true;
  }

  bool rowFilled(int row, int column) {
    for (int i = 0; i < board[0].length; ++i) {
      if (board[row][i] == null) {
        return false;
      }
      if (board[row][i] != board[row][column]) {
        return false;
      }
    }

    return true;
  }

  bool mainDiagonalFilled(int row, int column) {
    if (row != column) {
      return false;
    }

    for (int i = 0; i < board[0].length; ++i) {
      if (board[i][i] == null) {
        return false;
      }
      if (board[i][i] != board[row][column]) {
        return false;
      }
    }

    return true;
  }

  bool secondaryDiagonalFilled(int row, int column) {
    if (row + column != board[0].length - 1) {
      return false;
    }

    for (int i = 0; i < board[0].length; ++i) {
      int currentColumn = 0 + i;
      int currentRow = board[0].length - 1 - i;

      if (board[currentRow][currentColumn] == null) {
        return false;
      }
      if (board[currentRow][currentColumn] != board[row][column]) {
        return false;
      }
    }

    return true;
  }

  bool boardIsFull() {
    for (int i = 0; i < board[0].length; ++i) {
      for (int j = 0; j < board[0].length; ++j) {
        if (board[i][j] == null) {
          return false;
        }
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

  void showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          child: AlertDialog(
            title: const Icon(
              Icons.sentiment_satisfied_rounded,
              size: 48,
            ),
            content: Text(
              '${isFirstPlayersTurn ? player1.username : player2.username} won this round!',
              style: const TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Games menu',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      finishGame();
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Play Again',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void showStalemate() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          child: AlertDialog(
            title: const Icon(
              Icons.sentiment_neutral_rounded,
              size: 48,
            ),
            content: const Text(
              'Stalemate!',
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Main menu',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      finishGame();
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Play Again',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
