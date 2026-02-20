import 'dart:ui';

import 'package:flame/components.dart';

/// Плоский игровой мир
class GameWorld extends World {
  static const double _worldSize = 2000;

  @override
  Future<void> onLoad() async {
    // Фон — «земля» плоского мира
    await add(
      RectangleComponent(
        position: Vector2(-_worldSize / 2, -_worldSize / 2),
        size: Vector2.all(_worldSize),
        paint: Paint()..color = const Color(0xFF87C25A),
      ),
    );
  }
}
