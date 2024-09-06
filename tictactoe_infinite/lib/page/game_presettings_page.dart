import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe_infinite/model/game_settings.dart';
import 'package:tictactoe_infinite/page/game_page.dart';

class GamePresettingsPage extends StatefulWidget {
  final String settingsPageType;
  const GamePresettingsPage({super.key, required this.settingsPageType});

  @override
  State<StatefulWidget> createState() => GamePresettingsPageState();
}

class GamePresettingsPageState extends State<GamePresettingsPage> {
  late TextEditingController player1NameController;
  late TextEditingController player2NameController;

  late TextEditingController player1SymbolController;
  late TextEditingController player2SymbolController;

  @override
  void initState() {
    player1NameController = TextEditingController(text: GameSettings.player1Username);
    player2NameController = TextEditingController(text: GameSettings.player2Username);

    player1SymbolController = TextEditingController(text: GameSettings.player1Symbol);
    player2SymbolController = TextEditingController(text: GameSettings.player2Symbol);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            title: Text('${widget.settingsPageType} game settings')),
        body: SingleChildScrollView(
            child: widget.settingsPageType == 'custom'
                ? buildCustomOfflineMenu()
                : buildQuickMenu()));
  }

  Widget buildCustomOfflineMenu() {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height / 20),
      child: Column(
        children: [
          Text(
            'No player related changes result in usage of default values.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
              fontSize: 12,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Type of game',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                PopupMenuButton<GameType>(
                  onSelected: (type) {
                    Provider.of<GameSettings>(context, listen: false).gameType =
                        type;
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                        value: GameType.legacy, child: Text('Legacy')),
                    const PopupMenuItem(
                        value: GameType.infinite, child: Text('Infinite')),
                  ],
                  child: Row(
                    children: [
                      Text(
                        Provider.of<GameSettings>(context)
                            .getGameTypeAsString(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Icon(Icons.arrow_drop_down,
                          color: Theme.of(context).colorScheme.secondary),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Board size',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                PopupMenuButton<int>(
                  onSelected: (size) {
                    Provider.of<GameSettings>(context, listen: false)
                        .matrixSize = size;
                  },
                  itemBuilder: (context) {
                    return Provider.of<GameSettings>(context, listen: false)
                        .getMatrixSizes()
                        .map((value) {
                      return PopupMenuItem(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList();
                  },
                  child: Row(
                    children: [
                      Text(
                        '${Provider.of<GameSettings>(context).matrixSize}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Icon(Icons.arrow_drop_down,
                          color: Theme.of(context).colorScheme.secondary),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rounds to win',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                PopupMenuButton<int>(
                  onSelected: (numberOfRounds) {
                    Provider.of<GameSettings>(context, listen: false)
                        .roundsToWin = numberOfRounds;
                  },
                  itemBuilder: (context) {
                    return Provider.of<GameSettings>(context, listen: false)
                        .getNumberOfWins()
                        .map((value) {
                      return PopupMenuItem(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList();
                  },
                  child: Row(
                    children: [
                      Text(
                        '${Provider.of<GameSettings>(context).roundsToWin}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Icon(Icons.arrow_drop_down,
                          color: Theme.of(context).colorScheme.secondary),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Player1',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextField(
                    controller: player1NameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter first player name',
                    ),
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Player2',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextField(
                    controller: player2NameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter second player name',
                    ),
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),

          //symbols

          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Symbol1',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextField(
                    controller: player1SymbolController,
                    decoration: const InputDecoration(
                      hintText: 'Enter first player symbol',
                    ),
                    maxLength: 1,
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Symbol2',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextField(
                    controller: player2SymbolController,
                    decoration: const InputDecoration(
                      hintText: 'Enter second player symbol',
                    ),
                    maxLength: 1,
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),

          ElevatedButton(
            onPressed: () {
              switch (
                  Provider.of<GameSettings>(context, listen: false).gameType) {
                case GameType.infinite:
                  {
                    break;
                  }
                case GameType.legacy:
                  {
                    Provider.of<GameSettings>(context, listen: false).matrixSize=3;
                    Provider.of<GameSettings>(context, listen: false).gameType = GameType.legacy;
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GamePage(
                          player1Name: player1NameController.text.isNotEmpty
                              ? player1NameController.text
                              : GameSettings.player1Username,
                          player2Name: player2NameController.text.isNotEmpty
                              ? player2NameController.text
                              : GameSettings.player2Username,
                          player1Symbol: player1SymbolController.text.isNotEmpty
                              ? player1SymbolController.text
                              : GameSettings.player1Symbol,
                          player2Symbol: player2SymbolController.text.isNotEmpty
                              ? player2SymbolController.text
                              : GameSettings.player2Symbol,
                          player2IsBot: false,
                        ),
                      ),
                    );
                    break;
                  }
                default:
                  {
                    throw Exception(
                        'This type of game mode has not been implemented yet.');
                  }
              }
            },
            child: const Text('START GAME'),
          ),
        ],
      ),
    );
  }

  Widget buildQuickMenu() {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height / 20),
      child: Column(
        children: [
          Text(
            'No player related changes result in usage of default values.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
              fontSize: 12,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Type of game',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                PopupMenuButton<GameType>(
                  onSelected: (type) {
                    Provider.of<GameSettings>(context, listen: false).gameType =
                        type;
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                        value: GameType.legacy, child: Text('Legacy')),
                    const PopupMenuItem(
                        value: GameType.infinite, child: Text('Infinite')),
                  ],
                  child: Row(
                    children: [
                      Text(
                        Provider.of<GameSettings>(context)
                            .getGameTypeAsString(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Icon(Icons.arrow_drop_down,
                          color: Theme.of(context).colorScheme.secondary),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rounds to win',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                PopupMenuButton<int>(
                  onSelected: (numberOfRounds) {
                    Provider.of<GameSettings>(context, listen: false)
                        .roundsToWin = numberOfRounds;
                  },
                  itemBuilder: (context) {
                    return Provider.of<GameSettings>(context, listen: false)
                        .getNumberOfWins()
                        .map((value) {
                      return PopupMenuItem(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList();
                  },
                  child: Row(
                    children: [
                      Text(
                        '${Provider.of<GameSettings>(context).roundsToWin}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Icon(Icons.arrow_drop_down,
                          color: Theme.of(context).colorScheme.secondary),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Play as',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (symbol) {
                    setState(() {
                      player1SymbolController.text = symbol;
                    });
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'X', child: Text('X')),
                    const PopupMenuItem(value: 'O', child: Text('O')),
                  ],
                  child: Row(
                    children: [
                      Text(
                        player1SymbolController.text,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Icon(Icons.arrow_drop_down,
                          color: Theme.of(context).colorScheme.secondary),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              switch (
                  Provider.of<GameSettings>(context, listen: false).gameType) {
                case GameType.infinite:
                  {
                    break;
                  }
                case GameType.legacy:
                  {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GamePage(
                          player1Name: player1NameController.text.isNotEmpty
                              ? player1NameController.text
                              : GameSettings.player1Username,
                          player2Name: player2NameController.text.isNotEmpty
                              ? player2NameController.text
                              : GameSettings.player2Username,
                          player1Symbol: player1SymbolController.text,
                          player2Symbol: player1SymbolController.text == GameSettings.player1Symbol ? GameSettings.player2Symbol : GameSettings.player1Symbol,
                          player2IsBot: true,
                        ),
                      ),
                    );
                    break;
                  }
                default:
                  {
                    throw Exception(
                        'This type of game mode has not been implemented yet.');
                  }
              }
            },
            child: const Text('START GAME'),
          ),
        ],
      ),
    );
  }
}
