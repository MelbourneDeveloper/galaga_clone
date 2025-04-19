import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:galaga_clone/constants/game_constants.dart';
import 'package:galaga_clone/game/galaga_game.dart';
import 'package:galaga_clone/main.dart';
import 'package:galaga_clone/widgets/pause_menu.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  bool get _isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isMobile ? backgroundColor : desktopBackgroundColor,
      body: _isMobile
          ? _buildGameWidget()
          : Center(
              child: ClipRect(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: accentColor.withOpacity(0.3), width: 2),
                    color: backgroundColor,
                  ),
                  width: gameWidth,
                  height: gameHeight,
                  child: _buildGameWidget(),
                ),
              ),
            ),
    );
  }

  Widget _buildGameWidget() => GameWidget(
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
      );
}
