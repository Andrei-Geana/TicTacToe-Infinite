import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe_infinite/model/game_settings.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<StatefulWidget> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late List<List<String?>> board;

  @override
  void initState() {
    super.initState();
    initializeBoard();
  }

  void initializeBoard() {
    final matrixSize = context.read<GameSettings>().matrixSize;
    board = List.generate(
        matrixSize, (_) => List.generate(matrixSize, (_) => null));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildBoard(),
                const SizedBox(height: 150),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          resetGame();
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
        width: 75,
        height: 75,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        child: Text(
          cellValue ?? '',
          style: const TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void onCellTap(int row, int col) {
    if (board[row][col] == null) {
      setState(() {
        board[row][col] = 'O';
        if (moveWon(row, col)) {
          showAboutDialog(context: context);
        }
      });
    }
  }

  void resetGame() {
    setState(() {
      board = List.generate(
          context.read<GameSettings>().matrixSize,
          (_) => List.generate(
              context.read<GameSettings>().matrixSize, (_) => null));
    });
  }

  bool moveWon(int row, int column) {
    return columnFilled(row, column) || rowFilled(row, column);
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
}
