import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe_infinite/model/game_settings.dart';
import 'package:tictactoe_infinite/page/main_page.dart';
import 'package:tictactoe_infinite/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ChangeNotifierProvider(create: (context) => GameSettings())
  ], child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const MainPage(),
        theme: Provider.of<ThemeProvider>(context).themeData);
  }
}
