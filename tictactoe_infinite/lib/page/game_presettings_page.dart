import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe_infinite/model/game_settings.dart';
import 'package:tictactoe_infinite/page/game_page.dart';

class GamePresettingsPage extends StatefulWidget {
  const GamePresettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => GamePresettingsPageState();
}

class GamePresettingsPageState extends State<GamePresettingsPage> {
  late TextEditingController player1Controller;
  late TextEditingController player2Controller;

  @override
  void initState() {
    player1Controller = TextEditingController();
    player2Controller = TextEditingController();
    player1Controller.text = 'player1';
    player2Controller.text = 'player2';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height / 20),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                        Provider.of<GameSettings>(context, listen: false)
                            .gameType = type;
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                            value: GameType.legacy, child: Text('LEGACY')),
                        const PopupMenuItem(
                            value: GameType.infinite, child: Text('INFINITE')),
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
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Matrix size',
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
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                        controller: player1Controller,
                        decoration: const InputDecoration(
                          hintText: 'Enter name',
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
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                        controller: player2Controller,
                        decoration: const InputDecoration(
                          hintText: 'Enter name',
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
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  switch (Provider.of<GameSettings>(context, listen: false)
                      .gameType) {
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
                              player1Name: player1Controller.text,
                              player2Name: player2Controller.text,
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
        ),
      ),
    );
  }
}
