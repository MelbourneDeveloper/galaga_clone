import 'package:flame/camera.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galaga_clone/components/player.dart';
import 'package:galaga_clone/components/enemy_manager.dart';
import 'package:galaga_clone/components/background.dart';
import 'package:galaga_clone/components/hud.dart';
import 'package:galaga_clone/components/enemy.dart';
import 'package:galaga_clone/components/bullet.dart';

class GalagaGame extends FlameGame with KeyboardEvents, HasCollisionDetection {
  late Player player;
  late EnemyManager enemyManager;
  late Hud hud;
  int score = 0;
  int lives = 3;
  bool gameOver = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewport = FixedResolutionViewport(
      resolution:
          Vector2(400, 800), // Use constants directly until we fix imports
    );
    add(SpaceBackground());
    player = Player();
    add(player);
    enemyManager = EnemyManager();
    add(enemyManager);
    hud = Hud();
    add(hud);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameOver) return;
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        player.moveLeft();
      }
      if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        player.moveRight();
      }
      if (keysPressed.contains(LogicalKeyboardKey.space)) {
        player.shoot();
      }
    } else if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
          event.logicalKey == LogicalKeyboardKey.arrowRight) {
        player.stopMoving();
      }
    }
    return KeyEventResult.handled;
  }

  void increaseScore(int points) {
    score += points;
    hud.updateScore(score);
  }

  void playerHit() {
    lives--;
    hud.updateLives(lives);

    if (lives <= 0) {
      gameOver = true;
      player.explode();
      hud.showGameOver();
    } else {
      player.reset();
    }
  }

  void reset() {
    score = 0;
    lives = 3;
    gameOver = false;

    children.whereType<Enemy>().forEach((enemy) => enemy.removeFromParent());
    children.whereType<Bullet>().forEach((bullet) => bullet.removeFromParent());

    player.reset();
    enemyManager.reset();
    hud.updateScore(score);
    hud.updateLives(lives);
  }
}
