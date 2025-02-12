import 'dart:ui';

import 'package:first_flame_game/actors/player.dart';
import 'package:flame/components.dart';
import 'dart:async';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flame/game.dart';

class Level extends World{
  String levelName;
  final Player player;
  Level({required this.levelName, required this.player});
  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2(16, 16));

    add(level);

    final spawnpointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');
    for (final spawnpoint in spawnpointsLayer!.objects) {
      switch (spawnpoint.class_) {
        case 'Player':
          player.position = Vector2(spawnpoint.x, spawnpoint.y);
          add(player);
          break;
      }
    }

    return super.onLoad();
  }
}
