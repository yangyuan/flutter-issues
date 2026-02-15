// Repro: ListView + 2 Tooltips → AXTree error on hover (Windows)
//
// Steps:
//   1. flutter run -d windows
//   2. Hover mouse over box A, then move to box B
//   3. Watch console for:
//      [ERROR:flutter/shell/platform/common/accessibility_bridge.cc(114)]
//      Failed to update ui::AXTree
//
// If this reproduces in pure Flutter, it's a Flutter framework bug.
// If it does NOT reproduce, it's a Flut-specific issue.

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AXTree Tooltip Repro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TooltipReproPage(),
    );
  }
}

class TooltipReproPage extends StatelessWidget {
  const TooltipReproPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AXTree Tooltip Repro')),
      body: ListView(
        children: [
          Row(
            children: [
              Tooltip(
                message: 'Tooltip A',
                child: Container(
                  width: 100,
                  height: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      width: 1,
                      color: const Color(0xFF90CAF9),
                    ),
                  ),
                  child: const Text('A'),
                ),
              ),
              const SizedBox(width: 16),
              Tooltip(
                message: 'Tooltip B',
                child: Container(
                  width: 100,
                  height: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      width: 1,
                      color: const Color(0xFFE0E0E0),
                    ),
                  ),
                  child: const Text('B'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
