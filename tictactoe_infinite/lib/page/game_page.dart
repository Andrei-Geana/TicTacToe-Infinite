import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe_infinite/model/game_settings.dart';
import 'package:tictactoe_infinite/model/legacy_game_logic.dart';

class GamePage extends StatefulWidget {
  final String player1Name, player2Name, player1Symbol, player2Symbol;
  final bool player2IsBot;
  const GamePage(
      {super.key,
      required this.player1Name,
      required this.player2Name,
      required this.player1Symbol,
      required this.player2Symbol,
      required this.player2IsBot});

  @override
  State<StatefulWidget> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late GameLogic gameLogic;
  late int numberOfWins = context.read<GameSettings>().roundsToWin;
  late double cellHeight, cellWidth, cellMarkSize;
  late bool player2IsBot;

  @override
  void initState() {
    player2IsBot = widget.player2IsBot;
    final matrixSize = context.read<GameSettings>().matrixSize;
    gameLogic = GameLogic(widget.player1Name, widget.player1Symbol,
        widget.player2Name, widget.player2Symbol, matrixSize);
    gameLogic.initializeBoard();
    gameLogic.pickWhoMovesFirst();
    if (!gameLogic.isFirstPlayersTurn && player2IsBot) {
      makeBotMove();
    }
    initializeCellSizes(matrixSize);
    super.initState();
  }

  void initializeCellSizes(int matrixSize) {
    switch (matrixSize) {
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

  String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text(Provider.of<GameSettings>(context).getGameTypeAsString()),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(
              children: [
                Text(
                  'BEST OF $numberOfWins',
                  style: const TextStyle(letterSpacing: 3),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          gameLogic.player1.symbol,
                          style: const TextStyle(
                            fontSize: 60,
                          ),
                        ),
                        Text(
                          truncateText(gameLogic.player1.username, 13),
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
                          gameLogic.player2.symbol,
                          style: const TextStyle(
                            fontSize: 60,
                          ),
                        ),
                        Text(
                          truncateText(gameLogic.player2.username, 13),
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
                    Text(
                      truncateText(
                          gameLogic.player1.numberOfWins.toString(), 10),
                    ),
                    Text(
                      truncateText(
                          gameLogic.player2.numberOfWins.toString(), 10),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  '${truncateText(gameLogic.isFirstPlayersTurn ? gameLogic.player1.username : gameLogic.player2.username, 13)} now moves.',
                ),
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
        onPressed: onResetButtonTap,
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
    final cellValue = gameLogic.board[row][col];
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

  void onResetButtonTap() {
    setState(() {
      gameLogic.resetBoard();
      gameLogic.pickWhoMovesFirst();
      if (!gameLogic.isFirstPlayersTurn && player2IsBot) {
        makeBotMove();
      }
    });
  }

  void onCellTap(int row, int col) {
    if (player2IsBot && !gameLogic.isFirstPlayersTurn) {
      return;
    }
    if (gameLogic.board[row][col] == null) {
      setState(() {
        gameLogic.board[row][col] = gameLogic.getSymbolForMove();
        if (gameLogic.moveWon(row, col)) {
          if (gameLogic.isFirstPlayersTurn) {
            gameLogic.player1.numberOfWins++;
            if (gameLogic.player1.numberOfWins == numberOfWins) {
              showFinalResult(gameLogic.player1.username);
              return;
            }
          } else {
            gameLogic.player2.numberOfWins++;
            if (gameLogic.player2.numberOfWins == numberOfWins) {
              showFinalResult(gameLogic.player2.username);
              return;
            }
          }
          showRoundResult();
          return;
        } else if (gameLogic.boardIsFull()) {
          showStalemate();
          return;
        }
        if (player2IsBot) {
          gameLogic.isFirstPlayersTurn = false;
          makeBotMove();
        } else {
          gameLogic.switchTurn();
        }
      });
    }
  }

  void makeBotMove() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final bestMove = await gameLogic.findBestMoveWithAlphaBeta();
    int row = bestMove[0];
    int column = bestMove[1];
    setState(() {
      gameLogic.board[row][column] = gameLogic.player2.symbol;

      if (gameLogic.moveWon(row, column)) {
        gameLogic.player2.numberOfWins++;
        if (gameLogic.player2.numberOfWins == numberOfWins) {
          showFinalResult(gameLogic.player2.username);
          return;
        }
        showRoundResult();
        return;
      } else if (gameLogic.boardIsFull()) {
        showStalemate();
        return;
      }

      gameLogic.switchTurn();
    });
  }

  void finishGame() {
    setState(() {
      gameLogic.resetBoard();
      gameLogic.pickWhoMovesFirst();
      if (!gameLogic.isFirstPlayersTurn && player2IsBot) {
        makeBotMove();
      }
    });
  }

  void showRoundResult() {
    if (!player2IsBot) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return PopScope(
            child: AlertDialog(
              title: const Icon(
                Icons.star_half_outlined,
                size: 48,
              ),
              content: Text(
                '${gameLogic.isFirstPlayersTurn ? gameLogic.player1.username : gameLogic.player2.username} won this round!',
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
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return PopScope(
            child: AlertDialog(
              title: const Icon(
                Icons.star_half_outlined,
                size: 48,
              ),
              content: Text(
                'You${gameLogic.isFirstPlayersTurn ? ' won ' : ' lost '}this round!',
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

  void showFinalResult(String usernameOfWinner) {
    if (!player2IsBot) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return PopScope(
            child: AlertDialog(
              title: const Icon(
                Icons.star_outlined,
                size: 48,
              ),
              content: Text(
                '$usernameOfWinner won the game!',
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
                        gameLogic.resetScores();
                        finishGame();
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Reset and play again',
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
    else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return PopScope(
            child: AlertDialog(
              title: const Icon(
                Icons.star_outlined,
                size: 48,
              ),
              content: Text(
                'You ${usernameOfWinner == GameSettings.player1Username ? 'won' : 'lost'} the game!' ,
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
                        gameLogic.resetScores();
                        finishGame();
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Reset and play again',
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
}
