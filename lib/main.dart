import 'dart:io' show Platform;
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'
    if (Platform.isAndroid) 'package:flutter/cupertino.dart';

import 'package:first_flame_game/pixel_adventure.dart';

import 'package:flutter/cupertino.dart';
import 'package:flame/game.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  PixelAdventure game = PixelAdventure();
  runApp(GameWidget(game: kDebugMode ? PixelAdventure() : game),
  );
}
