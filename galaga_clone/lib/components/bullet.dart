import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../constants/game_constants.dart';
import '../game/galaga_game.dart';

enum BulletOwner { player, enemy }

class Bullet extends SpriteComponent
    with HasGameRef<GalagaGame>, CollisionCallbacks {
  final BulletOwner owner;
  late double speed;

  Bullet({required this.owner, required Vector2 position})
    : super(size: Vector2(5, 10), position: position) {
    speed = owner == BulletOwner.player ? playerBulletSpeed : enemyBulletSpeed;
  }

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite(
      owner == BulletOwner.player ? 'player_bullet.png' : 'enemy_bullet.png',
    );
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Player bullets move up, enemy bullets move down
    position.y += (owner == BulletOwner.player ? -1 : 1) * speed * dt;

    // Remove if bullet goes off screen
    if (position.y < -size.y || position.y > gameRef.size.y) {
      removeFromParent();
    }
  }
}
