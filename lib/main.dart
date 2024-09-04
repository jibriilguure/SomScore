import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'home/bottom_nav.dart';
import 'international/sections/competition/model/competition_model.dart';
import 'international/sections/competition/screen/competition_details.dart';
import 'international/sections/competition/screen/competition_screen.dart';

void main() async {
  // Initialize Hive and specify a path for the boxes
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(CompetitionAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SomScore',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const BottomNavScreen(),
        '/competition': (context) => CompetitionScreen(),
        // '/details': (context) => CompetitionDetailScreen(),
      },
    );
  }
}
