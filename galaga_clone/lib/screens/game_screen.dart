import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:galaga_clone/constants/game_constants.dart';
import 'package:galaga_clone/game/galaga_game.dart';
import 'package:galaga_clone/main.dart';
import 'package:galaga_clone/widgets/pause_menu.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: GameWidget(
        game: GalagaGame(),
        loadingBuilder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(accentColor),
          ),
        ),
        errorBuilder: (context, error) => Center(
          child: Text(
            'Error occurred: $error',
            style: const TextStyle(color: Colors.red, fontSize: 20),
          ),
        ),
        overlayBuilderMap: {'pauseMenu': (_, game) => const PauseMenu()},
      ),
    );
  }
}
