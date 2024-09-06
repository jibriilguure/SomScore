import 'package:flutter/material.dart';
import 'model/top_scorer_model.dart';
import 'player_scorer_widget.dart';
import 'top_scorers_service.dart';

class TopScorersScreen extends StatefulWidget {
  final int leagueId;
  final String season;

  const TopScorersScreen({
    super.key,
    required this.leagueId,
    required this.season,
  });

  @override
  State<TopScorersScreen> createState() => _TopScorersScreenState();
}

class _TopScorersScreenState extends State<TopScorersScreen> {
  late Future<List<Player>> futureTopScorers;
  final topScorersService = TopScorersService();

  @override
  void initState() {
    super.initState();
    futureTopScorers =
        topScorersService.fetchTopScorers(widget.leagueId, widget.season);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(width: 20),
                    Text("#", style: TextStyle(color: Colors.grey)),
                    SizedBox(width: 50),
                    Text("Player", style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Row(
                  children: [
                    Text("Goals", style: TextStyle(color: Colors.grey)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),

            // Top Scorers Container
            Expanded(
              child: FutureBuilder<List<Player>>(
                future: futureTopScorers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Error: ${snapshot.error}',
                            style: const TextStyle(color: Colors.red)));
                  } else if (snapshot.hasData) {
                    final players = snapshot.data!;
                    return ListView.builder(
                      itemCount: players.length,
                      itemBuilder: (context, index) {
                        final player = players[index];
                        return PlayerCard(
                          rank: (index + 1).toString(),
                          playerName: player.name,
                          teamName:
                              player.team.name, // Correctly pass the team name
                          goals: player.totalGoals.toString(),
                          imageUrl: player.photo ?? '', // Handle nullable photo
                        );
                      },
                    );
                  } else {
                    return const Center(
                        child: Text('No data found',
                            style: TextStyle(color: Colors.white)));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
