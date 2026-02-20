import 'package:flame/components.dart';
import 'package:flame/flame.dart';

/// Цель — точка, до которой нужно дойти
class Target extends SpriteComponent {
  static const double _displaySize = 160;

  Target({super.position})
      : super(
          size: Vector2.all(_displaySize),
          anchor: Anchor.center,
          priority: 5,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = Sprite(Flame.images.fromCache('target.jpg'));
  }
}
