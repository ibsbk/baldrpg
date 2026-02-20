import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/services.dart';

enum PlayerDirection { down, left, right, up }

/// Пиксельный персонаж — walk sheet 3x4 кадров (128×128)
class Player extends SpriteAnimationGroupComponent<PlayerDirection>
    with KeyboardHandler {
  final double _speed = 200;
  final Vector2 _velocity = Vector2.zero();

  // Размер отображения (спрайт 128×128 масштабируется)
  static const double _displaySize = 96;

  Player({super.position})
      : super(
          size: Vector2.all(_displaySize),
          anchor: Anchor.center,
          priority: 10,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final image = Flame.images.fromCache('player_walk_sheet.png');

    SpriteAnimation row(int rowIndex) {
      // 3 frames across, each 128×128. Middle frame = idle.
      return SpriteAnimation.fromFrameData(
        image,
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.14,
          textureSize: Vector2.all(128),
          texturePosition: Vector2(0, rowIndex * 128.0),
        ),
      );
    }

    animations = {
      PlayerDirection.down: row(0),
      PlayerDirection.left: row(1),
      PlayerDirection.right: row(2),
      PlayerDirection.up: row(3),
    };

    current = PlayerDirection.down;
    // Пока стоим — держим idle (средний кадр) и не тикаем.
    animationTicker?.setToLast();
    animationTicker?.paused = true;
    animationTicker?.currentIndex = 1;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += _velocity * dt;

    final moving = _velocity.length2 > 0;
    if (moving) {
      final ax = _velocity.x.abs();
      final ay = _velocity.y.abs();
      if (ax > ay) {
        current =
            _velocity.x < 0 ? PlayerDirection.left : PlayerDirection.right;
      } else {
        current = _velocity.y < 0 ? PlayerDirection.up : PlayerDirection.down;
      }
    }

    // Анимация играет только когда идём.
    final ticker = animationTicker;
    if (ticker != null) {
      if (moving) {
        ticker.paused = false;
      } else {
        ticker.paused = true;
        ticker.currentIndex = 1; // idle frame
      }
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _velocity.setZero();

    if (keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      _velocity.y = -_speed;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyS) ||
        keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      _velocity.y = _speed;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      _velocity.x = -_speed;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      _velocity.x = _speed;
    }

    // В Flame: false остановит распространение события по компонентам.
    // Нам нужно и движение, и интеракция — поэтому продолжаем распространение.
    return true;
  }
}
