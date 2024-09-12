import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package

import '../matchdetails/match_detail_screen.dart';
import 'fixture_model.dart';
import 'fixture_service.dart';

class FixturesScreen extends StatefulWidget {
  final int leagueId;
  final String season;

  const FixturesScreen({
    Key? key,
    required this.leagueId,
    required this.season,
  }) : super(key: key);

  @override
  State<FixturesScreen> createState() => _FixturesScreenState();
}

class _FixturesScreenState extends State<FixturesScreen> {
  late Future<List<Fixture>> futureFixtures;
  final fixtureService =
      FixtureService(); // Assuming service exists to fetch fixtures

  @override
  void initState() {
    super.initState();
    futureFixtures =
        fixtureService.fetchFixtures(widget.leagueId, widget.season);
  }

  // Function to group fixtures by date
  Map<String, List<Fixture>> _groupFixturesByDate(List<Fixture> fixtures) {
    Map<String, List<Fixture>> groupedFixtures = {};

    for (var fixture in fixtures) {
      // Format the fixture date
      String formattedDate = DateFormat('EEEE, dd MMMM yyyy')
          .format(DateTime.parse(fixture.date!));

      if (groupedFixtures.containsKey(formattedDate)) {
        groupedFixtures[formattedDate]!.add(fixture);
      } else {
        groupedFixtures[formattedDate] = [fixture];
      }
    }
    return groupedFixtures;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder<List<Fixture>>(
          future: futureFixtures,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red)),
              );
            } else if (snapshot.hasData) {
              final fixtures = snapshot.data!;
              final groupedFixtures = _groupFixturesByDate(fixtures);

              return ListView(
                children: groupedFixtures.keys.map((date) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          date,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Column(
                        children: groupedFixtures[date]!
                            .map((fixture) => GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) => MatchDetailScreen(
                                                  fixtureId: fixture.fixtureId,
                                                  status: 'FT',
                                                  // name: fixture.,
                                                )));
                                  },
                                  child: FixtureCard(
                                    date: fixture.date,
                                    homeTeam: fixture.homeTeam!,
                                    // fixture.fixtureId.toString(),
                                    // //TODO: CHANGE THIS LINE TO  'homeTeam' TO SEE THE HOME TEAM NAME ,
                                    awayTeam: fixture.awayTeam,
                                    homeTeamLogo: fixture.homeTeamLogo,
                                    awayTeamLogo: fixture.awayTeamLogo,
                                    homeScore: fixture.homeScore,
                                    awayScore: fixture.awayScore,
                                  ),
                                ))
                            .toList(),
                      )
                    ],
                  );
                }).toList(),
              );
            } else {
              return const Center(
                child: Text('No data found',
                    style: TextStyle(color: Colors.white)),
              );
            }
          },
        ),
      ),
    );
  }
}

// FixtureCard widget to display each fixture

class FixtureCard extends StatelessWidget {
  final String date;
  final String homeTeam;
  final String awayTeam;
  final String homeTeamLogo;
  final String awayTeamLogo;
  final int homeScore;
  final int awayScore;

  const FixtureCard({
    Key? key,
    required this.date,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeTeamLogo,
    required this.awayTeamLogo,
    required this.homeScore,
    required this.awayScore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Home team name
                Expanded(
                  child: Text(
                    homeTeam,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.end, // Align text to the right
                  ),
                ),
                const SizedBox(width: 10),

                // Home team logo
                Image.network(homeTeamLogo, width: 30, height: 30),

                const SizedBox(width: 10),

                // Home team score
                Text(
                  homeScore.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                // Score separator
                const Text(
                  ' : ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                // Away team score
                Text(
                  awayScore.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(width: 10),

                // Away team logo
                Image.network(awayTeamLogo, width: 30, height: 30),

                const SizedBox(width: 10),

                // Away team name
                Expanded(
                  child: Text(
                    awayTeam,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.start, // Align text to the left
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
