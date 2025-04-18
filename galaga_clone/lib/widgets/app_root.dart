import 'package:flutter/material.dart';
import 'package:galaga_clone/screens/game_screen.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: 'Galaga Clone',
        home: GameScreen(),
      );
}
