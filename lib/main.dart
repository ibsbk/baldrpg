import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/flat_world_game.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameWidget(
        game: FlatWorldGame(),
        overlayBuilderMap: {
          FlatWorldGame.victoryOverlayId: (context, game) => const _VictoryOverlay(),
        },
      ),
    ),
  );
}

class _VictoryOverlay extends StatelessWidget {
  const _VictoryOverlay();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xCC000000),
      child: Center(
        child: Text(
          'ПОБЕДА',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ) ??
              const TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
        ),
      ),
    );
  }
}
