import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/text.dart';
import 'package:flutter/services.dart';

import 'game_world.dart';
import 'player.dart';
import 'target.dart';

/// Игра с плоским миром и игроком
class FlatWorldGame extends FlameGame<GameWorld> with HasKeyboardHandlerComponents {
  FlatWorldGame() : super(world: GameWorld());

  late final Player _player;
  late final Target _target;

  static const double _useDistance = 120;
  static const String victoryOverlayId = 'victory';

  // Создаём сразу, потому что onGameResize может вызваться до onLoad (особенно на web).
  final TextComponent _useHint = TextComponent(
    text: '',
    anchor: Anchor.bottomCenter,
    priority: 1000,
    textRenderer: TextPaint(
      style: const TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 22,
        fontWeight: FontWeight.w700,
        shadows: [
          Shadow(
            color: Color(0xCC000000),
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
    ),
  );

  bool _isNearTarget = false;
  bool _hasWon = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await Flame.images.load('player_walk_sheet.png');
    await Flame.images.load('target.jpg');

    _player = Player(position: Vector2.zero());
    _target = Target(position: Vector2(400, 0));

    await world.add(_target);
    await world.add(_player);

    await camera.viewport.add(_useHint);

    // Отдельный обработчик клавиш для интеракций (E).
    await add(_UseKeyHandler(this));

    camera.follow(_player);
    camera.viewfinder.zoom = 1.5;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _useHint.position = Vector2(size.x / 2, size.y - 24);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_hasWon) return;

    final distance = _player.position.distanceTo(_target.position);
    final near = distance <= _useDistance;
    if (near != _isNearTarget) {
      _isNearTarget = near;
      _useHint.text = _isNearTarget ? 'E использовать' : '';
    }
  }

  void _tryUseTarget() {
    if (_hasWon || !_isNearTarget) return;

    _hasWon = true;
    _useHint.text = '';

    overlays.add(victoryOverlayId);
    pauseEngine();
  }
}

class _UseKeyHandler extends Component with KeyboardHandler {
  _UseKeyHandler(this._game);

  final FlatWorldGame _game;

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.keyE) {
      _game._tryUseTarget();
    }
    // Не блокируем распространение (иначе Player не получит WASD).
    return true;
  }
}
