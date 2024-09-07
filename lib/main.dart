import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:somscore/international/sections/competition/screen/stainding/cup_standing_model.dart';
import 'package:somscore/international/sections/competition/screen/stainding/league_standing_model.dart';

import 'home/bottom_nav.dart';
import 'international/sections/competition/model/competition_model.dart';

import 'international/sections/competition/screen/competition_screen.dart';
import 'international/sections/competition/screen/fixture_screen/fixture_model.dart';
import 'international/sections/competition/screen/sub-screens/model/top_scorer_model.dart';

void main() async {
  // Initialize Hive and specify a path for the boxes
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(CompetitionAdapter());
  Hive.registerAdapter(PlayerAdapter());
  Hive.registerAdapter(TeamAdapter());
  Hive.registerAdapter(FixtureAdapter());
  Hive.registerAdapter(LeagueStandingAdapter());
  Hive.registerAdapter(CupStandingAdapter());

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
