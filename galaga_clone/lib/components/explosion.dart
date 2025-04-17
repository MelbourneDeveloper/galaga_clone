import 'package:flame/components.dart';
import '../constants/game_constants.dart';
import '../game/galaga_game.dart';

class Explosion extends SpriteAnimationComponent with HasGameRef<GalagaGame> {
  Explosion({required Vector2 position, required Vector2 size})
    : super(
        position: position,
        size: size,
        anchor: Anchor.center,
        removeOnFinish: true,
      );

  @override
  Future<void> onLoad() async {
    final spriteSheet = await gameRef.images.load('explosion.png');
    final spriteSize = Vector2(64, 64);

    animation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 16,
        stepTime: explosionDuration / 16,
        textureSize: spriteSize,
        loop: false,
      ),
    );
  }
}
