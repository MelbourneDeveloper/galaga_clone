import 'dart:math';
import 'package:flame/components.dart';
import '../constants/game_constants.dart';
import '../game/galaga_game.dart';
import 'enemy.dart';

class EnemyManager extends Component with HasGameRef<GalagaGame> {
  int currentWave = 0;
  final Random _random = Random();
  double _spawnTimer = 0;
  int _enemiesSpawned = 0;
  bool _isSpawning = false;

  @override
  Future<void> onLoad() async {
    await Future.delayed(const Duration(seconds: 2));
    _startNextWave();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Check if current wave is complete
    if (!_isSpawning && children.isEmpty) {
      _startNextWave();
    }

    // Handle spawning timing
    if (_isSpawning) {
      _spawnTimer -= dt;
      if (_spawnTimer <= 0) {
        _spawnEnemy();
        _spawnTimer = 0.2; // Time between enemy spawns
      }
    }
  }

  void _startNextWave() {
    currentWave++;
    _isSpawning = true;
    _enemiesSpawned = 0;
  }

  void _spawnEnemy() {
    if (_enemiesSpawned >= enemiesPerWave) {
      _isSpawning = false;
      return;
    }

    final row = _enemiesSpawned ~/ enemyColumns;
    final col = _enemiesSpawned % enemyColumns;

    // Calculate formation position
    final formationX =
        (gameWidth - (enemyColumns * (enemyWidth + enemyPadding))) / 2 +
        col * (enemyWidth + enemyPadding) +
        enemyWidth / 2;
    final formationY =
        enemyFormationTopPadding + row * (enemyHeight + enemyPadding);

    final formationPosition = Vector2(formationX, formationY);

    // Determine enemy type - bosses in first row
    final enemyType = row == 0 ? EnemyType.boss : EnemyType.standard;

    // Create and add the enemy
    final enemy = Enemy(type: enemyType, formationPosition: formationPosition);

    // Add some variation to starting positions for more interesting entry
    final startX = _random.nextDouble() * gameWidth;
    enemy.position = Vector2(startX, -enemyHeight);

    add(enemy);
    _enemiesSpawned++;
  }

  void reset() {
    children.whereType<Enemy>().forEach((enemy) => enemy.removeFromParent());
    currentWave = 0;
    _isSpawning = false;
    _enemiesSpawned = 0;
    _startNextWave();
  }
}
