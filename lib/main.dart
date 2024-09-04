import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'home/bottom_nav.dart';
import 'international/sections/competition/model/competition_model.dart';

void main() async {
  // Initialize Hive and specify a path for the boxes
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(CompetitionAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Som Score',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const BottomNavScreen());
  }
}
