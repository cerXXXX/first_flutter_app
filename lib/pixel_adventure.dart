import 'package:first_flame_game/actors/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:first_flame_game/levels/level.dart';
import 'dart:async';
import 'package:flame/extensions.dart';
import 'package:flutter/cupertino.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  Player player = Player(character: 'Mask Dude');
  late JoystickComponent joystick;
  bool showJoystick = true;

  @override
  FutureOr<void> onLoad() async {
    // load all img in cache
    await images.loadAllImages();

    final world = Level(levelName: 'Level-02', player: player);

    camera = CameraComponent.withFixedResolution(
        world: world, width: 640, height: 360);
    camera.viewfinder.anchor = Anchor.topLeft;

    add(world);

    if (showJoystick) addJoystick();

    return super.onLoad();
  }

  @override
  void update(double dt){
    updateJoystick();
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
        knob: SpriteComponent(sprite: Sprite(images.fromCache('HUD/Knob.png'))),
        background: SpriteComponent(
            sprite: Sprite(images.fromCache('HUD/Joystick.png'))),
        margin: const EdgeInsets.only(left: 32, bottom: 32)
    );
    camera.viewport.add(joystick);
  }

  void updateJoystick() {
    if (!showJoystick) return;
    switch (joystick.direction){
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.playerDirection = PlayerDirection.left;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.playerDirection = PlayerDirection.right;
        break;
      default:
        player.playerDirection = PlayerDirection.none;
        break;
    }
  }
}
