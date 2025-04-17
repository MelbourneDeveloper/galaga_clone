import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'dart:math' as math;
import '../constants/game_constants.dart';
import '../game/galaga_game.dart';
import 'bullet.dart';
import 'explosion.dart';

class Player extends SpriteComponent
    with HasGameRef<GalagaGame>, CollisionCallbacks {
  double moveSpeed = playerShipSpeed;
  int direction = 0; // -1 left, 0 idle, 1 right
  double shootCooldown = 0;
  bool canShoot = true;

  Player() : super(size: Vector2(playerShipWidth, playerShipHeight));

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('player_ship.png');
    position = Vector2(
      gameRef.size.x / 2 - size.x / 2,
      gameRef.size.y - size.y - 20,
    );
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Handle horizontal movement
    position.x += direction * moveSpeed * dt;

    // Keep player within screen bounds
    position.x = position.x.clamp(0, gameRef.size.x - size.x);

    // Handle shooting cooldown
    if (!canShoot) {
      shootCooldown -= dt;
      if (shootCooldown <= 0) {
        canShoot = true;
      }
    }
  }

  void moveLeft() {
    direction = -1;
  }

  void moveRight() {
    direction = 1;
  }

  void stopMoving() {
    direction = 0;
  }

  void shoot() {
    if (canShoot) {
      final bullet = Bullet(
        owner: BulletOwner.player,
        position: Vector2(position.x + size.x / 2 - 2.5, position.y - 10),
      );
      gameRef.add(bullet);

      canShoot = false;
      shootCooldown = playerShipFireRate;
    }
  }

  void reset() {
    position = Vector2(
      gameRef.size.x / 2 - size.x / 2,
      gameRef.size.y - size.y - 20,
    );
    direction = 0;
    canShoot = true;
    shootCooldown = 0;
  }

  void explode() {
    final explosion = Explosion(
      position: position + size / 2,
      size: Vector2.all(math.max(size.x, size.y) * 1.5),
    );
    gameRef.add(explosion);
    removeFromParent();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Bullet && other.owner == BulletOwner.enemy) {
      other.removeFromParent();
      gameRef.playerHit();
    }
  }
}
