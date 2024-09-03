import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe_infinite/component/custom_button.dart';
import 'package:tictactoe_infinite/model/game_settings.dart';
import 'package:tictactoe_infinite/page/game_page.dart';
import 'package:tictactoe_infinite/page/game_presettings_page.dart';
import 'package:tictactoe_infinite/page/settings_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final double buttonWidth = 250;
  final double buttonHeight = 75;
  final double offset = 50;
  bool gameMenuPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: offset),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Tic-Tac-Toe Infinite',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                gameMenuPressed ? buildGamesMenu() : buildMainMenu(),
                const SizedBox(height: 20),
                Text(
                  'Quick start launches the legacy version of the game.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.3),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMainMenu() {
    return Column(
      children: [
        const SizedBox(height: 40),
        CustomButton(
          text: 'Quick start game',
          onPressed: () {
            GameSettings().matrixSize=3;
            GameSettings().roundsToWin=3;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GamePage(
                  player1Name: GameSettings.player1Username,
                  player2Name: GameSettings.player2Username,
                  player1Symbol: GameSettings.player1Symbol,
                  player2Symbol: GameSettings.player2Symbol,
                ),
              ),
            );
          },
          width: buttonWidth,
          height: buttonHeight,
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: 'Games menu',
          onPressed: () {
            setState(() {
              gameMenuPressed = true;
            });
          },
          width: buttonWidth,
          height: buttonHeight,
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: 'Settings',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          },
          width: buttonWidth,
          height: buttonHeight,
        ),
      ],
    );
  }

  Widget buildGamesMenu() {
    return Column(
      children: [
        const SizedBox(height: 40),
        CustomButton(
          text: 'Start game (OFFLINE)',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GamePresettingsPage(),
              ),
            );
          },
          width: buttonWidth,
          height: buttonHeight,
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: 'Start game (ONLINE)',
          onPressed: () {
            switch (
                Provider.of<GameSettings>(context, listen: false).gameType) {
              case GameType.infinite:
                {
                  break;
                }
              case GameType.legacy:
                {
                  break;
                }
              default:
                {
                  throw Exception(
                      'This type of game mode has not been implemented yet.');
                }
            }
          },
          width: buttonWidth,
          height: buttonHeight,
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: 'Go back',
          onPressed: () {
            setState(() {
              gameMenuPressed = false;
            });
          },
          width: buttonWidth,
          height: buttonHeight,
        ),
      ],
    );
  }
}
