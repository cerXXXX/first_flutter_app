import 'dart:async';
import 'dart:io' show Platform;
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'
if (Platform.isAndroid) 'package:flutter/cupertino.dart';

import 'package:first_flame_game/pixel_adventure.dart';
import 'package:flame/game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  // Создаём глобальный ErrorNotifier для хранения ошибок
  final errorNotifier = ErrorNotifier();

  // Перехватываем ошибки Flutter
  FlutterError.onError = (FlutterErrorDetails details) {
    errorNotifier.addError(details.toString());
    FlutterError.dumpErrorToConsole(details);
  };

  // Запускаем приложение в зоне, перехватывающей ошибки runZonedGuarded
  runZonedGuarded(() {
    PixelAdventure game = PixelAdventure();
    runApp(MyApp(game: game, errorNotifier: errorNotifier));
  }, (error, stackTrace) {
    errorNotifier.addError('$error\n$stackTrace');
  });
}

/// Класс, который хранит список ошибок и уведомляет слушателей об изменениях
class ErrorNotifier extends ChangeNotifier {
  final List<String> _errors = [];
  List<String> get errors => List.unmodifiable(_errors);

  void addError(String error) {
    _errors.add(error);
    notifyListeners();
  }
}

/// Виджет, отображающий ошибки поверх всего экрана
class ErrorOverlay extends StatelessWidget {
  final ErrorNotifier errorNotifier;
  const ErrorOverlay({Key? key, required this.errorNotifier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: errorNotifier,
        builder: (context, child) {
          if (errorNotifier.errors.isEmpty) {
            return const SizedBox.shrink();
          }
          return Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.black.withOpacity(0.7),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: errorNotifier.errors
                    .map((e) => Text(e,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    )))
                    .toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Основное приложение, которое объединяет GameWidget и ErrorOverlay
class MyApp extends StatelessWidget {
  final PixelAdventure game;
  final ErrorNotifier errorNotifier;
  const MyApp({Key? key, required this.game, required this.errorNotifier})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixel Adventure',
      home: Scaffold(
        body: Stack(
          children: [
            GameWidget(game: game),
            ErrorOverlay(errorNotifier: errorNotifier),
          ],
        ),
      ),
    );
  }
}
