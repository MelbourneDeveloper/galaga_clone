import 'package:flutter/material.dart';
import 'package:galaga_clone/screens/game_screen.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Galaga Clone',
        home: GameScreen(),
      );
}
