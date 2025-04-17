import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../constants/game_constants.dart';
import '../game/galaga_game.dart';
import 'bullet.dart';
import 'explosion.dart';

enum EnemyType { standard, boss }

enum EnemyState { formation, diving, returning }

class Enemy extends SpriteComponent
    with HasGameRef<GalagaGame>, CollisionCallbacks {
  final EnemyType type;
  final Vector2 formationPosition;
  EnemyState state = EnemyState.formation;
  late Vector2 targetPosition;
  final Random _random = Random();
  double _shootTimer = 0;
  final double _fireRate;
  final List<Vector2> _divePath = [];
  int _divePathIndex = 0;

  Enemy({required this.type, required this.formationPosition})
    : _fireRate = enemyFireRate * (1 + Random().nextDouble()),
      super(
        size: Vector2(enemyWidth, enemyHeight),
        position: Vector2(formationPosition.x, -enemyHeight),
      );

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite(
      type == EnemyType.standard ? 'enemy_standard.png' : 'enemy_boss.png',
    );
    add(RectangleHitbox());
    targetPosition = formationPosition.clone();
  }

  @override
  void update(double dt) {
    super.update(dt);

    switch (state) {
      case EnemyState.formation:
        _updateInFormation(dt);
        break;
      case EnemyState.diving:
        _updateDiving(dt);
        break;
      case EnemyState.returning:
        _updateReturning(dt);
        break;
    }

    // Enemy shooting logic
    _shootTimer -= dt;
    if (_shootTimer <= 0) {
      _shootTimer = _fireRate;
      _tryShoot();
    }
  }

  void _updateInFormation(double dt) {
    final distance = targetPosition - position;
    position += distance * min(dt * 5, 1);

    // Randomly decide to dive
    if (_random.nextDouble() < 0.002) {
      _startDiving();
    }
  }

  void _updateDiving(double dt) {
    if (_divePathIndex < _divePath.length) {
      final targetPoint = _divePath[_divePathIndex];
      final distance = targetPoint - position;

      if (distance.length < 10) {
        _divePathIndex++;
      } else {
        final direction = distance.normalized();
        position += direction * enemyDiveSpeed * dt;
      }
    } else {
      state = EnemyState.returning;
    }
  }

  void _updateReturning(double dt) {
    final distance = formationPosition - position;

    if (distance.length < 10) {
      position = formationPosition;
      state = EnemyState.formation;
    } else {
      final direction = distance.normalized();
      position += direction * enemyFormationSpeed * dt;
    }
  }

  void _startDiving() {
    state = EnemyState.diving;
    _divePathIndex = 0;
    _divePath.clear();

    // Create a diving path
    final playerPos = Vector2(
      gameRef.player.position.x + gameRef.player.size.x / 2,
      gameRef.player.position.y,
    );

    // Add some random control points
    _divePath.add(
      Vector2(
        position.x + _random.nextDouble() * 100 - 50,
        position.y + gameHeight * 0.3,
      ),
    );

    _divePath.add(
      Vector2(
        playerPos.x + _random.nextDouble() * 100 - 50,
        playerPos.y - gameHeight * 0.2,
      ),
    );

    _divePath.add(Vector2(playerPos.x, playerPos.y));

    _divePath.add(Vector2(_random.nextDouble() * gameWidth, -100));
  }

  void _tryShoot() {
    if (state == EnemyState.diving) {
      final bullet = Bullet(
        owner: BulletOwner.enemy,
        position: Vector2(position.x + size.x / 2 - 2.5, position.y + size.y),
      );
      gameRef.add(bullet);
    }
  }

  void explode() {
    final explosion = Explosion(
      position: position + size / 2,
      size: Vector2.all(max(size.x, size.y) * 1.5),
    );
    gameRef.add(explosion);

    // Add points
    gameRef.increaseScore(
      type == EnemyType.standard ? pointsPerStandardEnemy : pointsPerBossEnemy,
    );

    removeFromParent();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Bullet && other.owner == BulletOwner.player) {
      other.removeFromParent();
      explode();
    }
  }
}
