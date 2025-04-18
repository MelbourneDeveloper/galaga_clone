import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galaga_clone/screens/game_screen.dart';
import 'package:galaga_clone/widgets/app_root.dart';
import 'game/galaga_game.dart';
import 'constants/game_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialize Flame
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();

  runApp(const AppRoot());
}
