import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

late SoLoud soloud;
AudioSource? drawCard;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  soloud = SoLoud.instance;
await soloud.init();
  drawCard = await soloud.loadAsset(
      'assets/audio/draw_card.wav',
    );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
              disabledForegroundColor: Colors.red,
            ),
            onPressed: () async {
              if (drawCard != null) {
                await soloud.play(drawCard!);
              }
            },
            onLongPress: () async {
              if (drawCard != null) {
                await soloud.play(drawCard!);
              }
            },
            child: Text('TextButton'),
          ),
        ),
      ),
    );
  }
}
