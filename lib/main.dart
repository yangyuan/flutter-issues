import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'dart:developer' as dev;
import 'package:logging/logging.dart';

late SoLoud soloud;
AudioSource? drawCard;
AudioSource? drawCardUrl;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // Forward logs to the console.
    dev.log(
      record.message,
      time: record.time,
      level: record.level.value,
      name: record.loggerName,
      zone: record.zone,
      error: record.error,
      stackTrace: record.stackTrace,
    );
  });

  soloud = SoLoud.instance;
  await soloud.init();
  drawCard = await soloud.loadAsset('assets/audio/draw_card.wav');
  drawCardUrl = await soloud.loadUrl('assets/assets/audio/draw_card.wav');

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      soloud = SoLoud.instance;
      soloud.init().then((_) async {
        drawCard = await soloud.loadAsset('assets/audio/draw_card.wav');
        drawCardUrl = await soloud.loadUrl('assets/assets/audio/draw_card.wav');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.blue),
                onPressed: () async {
                  if (drawCard != null) {
                    await soloud.play(drawCard!);
                  }
                },
                onLongPress: () async {
                  if (drawCardUrl != null) {
                    await soloud.play(drawCardUrl!);
                  }
                },
                child: Text('Play Sound (Long Press to use URL source)'),
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () async {
                  soloud = SoLoud.instance;
                  await soloud.init();
                },
                child: Text('Re-init SoLoud'),
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () async {
                  drawCard = await soloud.loadAsset(
                    'assets/audio/draw_card.wav',
                  );
                  drawCardUrl = await soloud.loadUrl(
                    'assets/assets/audio/draw_card.wav',
                  );
                },
                child: Text('Reload AudioSources'),
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () async {
                  soloud = SoLoud.instance;
                  await soloud.init();
                  drawCard = await soloud.loadAsset(
                    'assets/audio/draw_card.wav',
                  );
                  drawCardUrl = await soloud.loadUrl(
                    'assets/assets/audio/draw_card.wav',
                  );
                },
                child: Text('Reset SoLoud'),
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.green),
                onPressed: () async {
                  print("start diagnosis");
                  soloud = SoLoud.instance;
                  print("start listPlaybackDevices");
                  var devices = soloud.listPlaybackDevices();
                  print("end listPlaybackDevices");
                  for (var device in devices) {
                    print(device.id);
                    print(device.isDefault);
                    print(device.name);
                  }
                },
                child: Text('Diagnosis'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
