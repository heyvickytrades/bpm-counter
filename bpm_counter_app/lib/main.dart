import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;
import 'providers/bpm_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => BpmProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BPM Counter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BpmCounterHome(title: 'BPM Counter'),
    );
  }
}

class BpmCounterHome extends StatelessWidget {
  const BpmCounterHome({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Platform.isIOS ? CupertinoIcons.hand_raised : Icons.touch_app,
                ),
                text: 'Tap Mode',
              ),
              Tab(
                icon: Icon(
                  Platform.isIOS ? CupertinoIcons.mic : Icons.mic,
                ),
                text: 'Auto Mode',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tap Mode Screen
            Center(
              child: buildTapModeContent(context),
            ),
            // Auto Mode Screen
            Center(
              child: buildAutoModeContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTapModeContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Tap Mode',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Consumer<BpmProvider>(
          builder: (context, bpmProvider, child) {
            return Text(
              'Tap Count: ${bpmProvider.tapCount}',
              style: const TextStyle(fontSize: 18),
            );
          },
        ),
        const SizedBox(height: 20),
        Platform.isIOS
            ? CupertinoButton(
                color: Theme.of(context).colorScheme.primary,
                child: const Text('Tap Here'),
                onPressed: () {
                  // Will implement tap action in Step 5
                },
              )
            : ElevatedButton(
                onPressed: () {
                  // Will implement tap action in Step 5
                },
                child: const Text('Tap Here'),
              ),
      ],
    );
  }

  Widget buildAutoModeContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Auto Mode',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Consumer<BpmProvider>(
          builder: (context, bpmProvider, child) {
            return Text(
              'Status: ${bpmProvider.autoModeStatus}',
              style: const TextStyle(fontSize: 18),
            );
          },
        ),
      ],
    );
  }
}
