import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:somscore/international/sections/screens/events/event_model.dart';
import 'package:somscore/international/sections/screens/matchdetails/model/fixture_model.dart';
import 'package:somscore/international/sections/screens/standings/cup_standing_model.dart';
import 'package:somscore/international/sections/screens/standings/league_standing_model.dart';

import 'home/bottom_nav.dart';
import 'international/sections/screens/competition/model/competition_model.dart';

import 'international/sections/screens/competition/screen/competition_screen.dart';
import 'international/sections/screens/fixture_screen/fixture_model.dart';
import 'international/sections/screens/top_scorers/model/top_scorer_model.dart';

void main() async {
  // Initialize Hive and specify a path for the boxes
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(CompetitionAdapter()); // 0
  Hive.registerAdapter(PlayerAdapter()); // 1
  Hive.registerAdapter(TeamAdapter()); //2
  Hive.registerAdapter(FixtureAdapter()); // 3
  Hive.registerAdapter(CupStandingAdapter()); // 5
  Hive.registerAdapter(LeagueStandingAdapter()); // 6

  // Register all type adapters
  Hive.registerAdapter(FixtureMatchDetailAdapter()); // 7
  Hive.registerAdapter(PeriodsAdapter()); // 8
  Hive.registerAdapter(VenueAdapter()); // 9
  Hive.registerAdapter(StatusAdapter()); // 10

  Hive.registerAdapter(TeamsMatchAdapter()); // 11
  Hive.registerAdapter(TeamsAdapter()); // typeId: 12
  Hive.registerAdapter(GoalsAdapter()); // typeId: 13
  Hive.registerAdapter(ScoreAdapter()); // typeId: 14
  Hive.registerAdapter(HalfScoreAdapter()); // typeId: 15

  // Register adapters for Event and all nested types
  Hive.registerAdapter(EventAdapter()); // Event model (typeId: 40)
  Hive.registerAdapter(TimeAdapter()); // Time model (typeId: 41)
  Hive.registerAdapter(EventTeamAdapter()); // EventTeam model (typeId: 42)
  Hive.registerAdapter(EventPlayerAdapter()); // EventPlayer model (typeId: 43)
  Hive.registerAdapter(AssistAdapter()); // Assist model (typeId: 44)

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
