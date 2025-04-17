import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../constants/game_constants.dart';
import '../game/galaga_game.dart';

class Hud extends PositionComponent with HasGameRef<GalagaGame> {
  late TextComponent _scoreText;
  late List<PositionComponent> _livesIcons;

  Hud() : super(priority: 20);

  @override
  Future<void> onLoad() async {
    _scoreText = TextComponent(
      text: 'SCORE: 0',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: primaryColor,
          fontSize: 20,
          fontFamily: 'Arcade',
        ),
      ),
      anchor: Anchor.topLeft,
      position: Vector2(20, 20),
    );
    add(_scoreText);

    // Create lives display
    _livesIcons = [];
    await _updateLivesDisplay(3);
  }

  void updateScore(int score) {
    _scoreText.text = 'SCORE: $score';
  }

  void updateLives(int lives) {
    for (final icon in _livesIcons) {
      icon.removeFromParent();
    }
    _livesIcons.clear();

    _updateLivesDisplay(lives);
  }

  Future<void> _updateLivesDisplay(int lives) async {
    final lifeSprite = await gameRef.loadSprite('player_ship.png');

    for (int i = 0; i < lives; i++) {
      final lifeIcon = SpriteComponent(
        sprite: lifeSprite,
        position: Vector2(gameWidth - 40 - (i * 35), 25),
        size: Vector2(30, 24),
        anchor: Anchor.center,
      );

      add(lifeIcon);
      _livesIcons.add(lifeIcon);
    }
  }

  void showGameOver() {
    final gameOverText = TextComponent(
      text: 'GAME OVER',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: primaryColor,
          fontSize: 48,
          fontFamily: 'Arcade',
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(gameWidth / 2, gameHeight / 2),
    );

    final restartText = TextComponent(
      text: 'PRESS SPACE TO RESTART',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: primaryColor,
          fontSize: 20,
          fontFamily: 'Arcade',
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(gameWidth / 2, gameHeight / 2 + 60),
    );

    add(gameOverText);
    add(restartText);
  }
}
