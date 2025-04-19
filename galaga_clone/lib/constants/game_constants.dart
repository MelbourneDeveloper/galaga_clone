import 'dart:ui';

/// Game window dimensions
const double gameWidth = 400;
const double gameHeight = 800;

/// Player ship constants
const double playerShipWidth = 60;
const double playerShipHeight = 48;
const double playerShipSpeed = 300;
const double playerShipFireRate = 0.5; // seconds between shots
const double playerBulletSpeed = 500;

/// Enemy constants
const double enemyWidth = 40;
const double enemyHeight = 40;
const double enemyBulletSpeed = 250;
const double enemyFireRate = 1.0; // seconds between shots
const double enemyFormationSpeed = 50;
const double enemyDiveSpeed = 180;

/// Game difficulty constants
const int enemiesPerWave = 40;
const int enemyRows = 5;
const int enemyColumns = 8;
const double enemyPadding = 15;
const double enemyFormationTopPadding = 100;

/// Explosion animation constants
const double explosionDuration = 0.5;

/// UI constants
const Color primaryColor = Color(0xFFFFFFFF);
const Color accentColor = Color(0xFF00FF00);
const Color backgroundColor = Color(0xFF000022);
const Color desktopBackgroundColor = Color(0xFF000035);

/// Score constants
const int pointsPerStandardEnemy = 50;
const int pointsPerBossEnemy = 150;
const int pointsPerFormationDestroyed = 500;

/// Power-up constants
const double powerUpDuration = 10.0;
const double powerUpSpeed = 100;
