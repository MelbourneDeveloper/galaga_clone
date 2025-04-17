import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../constants/game_constants.dart';
import '../game/galaga_game.dart';

class SpaceBackground extends Component with HasGameRef<GalagaGame> {
  final List<Star> _stars = [];
  final Random _random = Random();
  final int starCount = 100;

  @override
  Future<void> onLoad() async {
    for (int i = 0; i < starCount; i++) {
      _stars.add(
        Star(
          position: Vector2(
            _random.nextDouble() * gameWidth,
            _random.nextDouble() * gameHeight,
          ),
          radius: _random.nextDouble() * 1.5 + 0.5,
          speed: _random.nextDouble() * 30 + 20,
        ),
      );
    }

    for (final star in _stars) {
      add(star);
    }
  }
}

class Star extends CircleComponent with HasGameRef<GalagaGame> {
  final double speed;

  Star({required Vector2 position, required double radius, required this.speed})
    : super(
        position: position,
        radius: radius,
        paint: Paint()..color = Colors.white.withOpacity(0.8),
      );

  @override
  void update(double dt) {
    super.update(dt);

    position.y += speed * dt;

    if (position.y > gameRef.size.y) {
      position.y = 0;
      position.x = Random().nextDouble() * gameRef.size.x;
    }
  }
}
