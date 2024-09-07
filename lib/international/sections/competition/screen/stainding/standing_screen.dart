import 'package:flutter/material.dart';
import 'standing_service.dart';
import 'league_standing_model.dart';

class StandingsScreen extends StatefulWidget {
  final int leagueId;
  final String season;

  const StandingsScreen({
    Key? key,
    required this.leagueId,
    required this.season,
  }) : super(key: key);

  @override
  _StandingsScreenState createState() => _StandingsScreenState();
}

class _StandingsScreenState extends State<StandingsScreen> {
  late Future<List<LeagueStanding>> futureStandings;
  final standingService = StandingService();

  @override
  void initState() {
    super.initState();
    futureStandings =
        standingService.fetchLeagueStandings(widget.leagueId, widget.season);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder<List<LeagueStanding>>(
          future: futureStandings,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red)),
              );
            } else if (snapshot.hasData) {
              final standings = snapshot.data!;
              return DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                      label: Text('#', style: TextStyle(color: Colors.grey))),
                  DataColumn(
                      label:
                          Text('Club', style: TextStyle(color: Colors.grey))),
                  DataColumn(
                      label: Text('PL', style: TextStyle(color: Colors.grey))),
                  DataColumn(
                      label: Text('W', style: TextStyle(color: Colors.grey))),
                  DataColumn(
                      label: Text('D', style: TextStyle(color: Colors.grey))),
                  DataColumn(
                      label: Text('L', style: TextStyle(color: Colors.grey))),
                  DataColumn(
                      label: Text('GD', style: TextStyle(color: Colors.grey))),
                  DataColumn(
                      label: Text('PTS', style: TextStyle(color: Colors.grey))),
                ],
                rows: standings
                    .map(
                      (standing) => DataRow(
                        cells: [
                          DataCell(Text(standing.rank.toString(),
                              style: const TextStyle(color: Colors.white))),
                          DataCell(Row(
                            children: [
                              Image.network(standing.teamLogo, width: 20),
                              const SizedBox(width: 8),
                              Text(standing.teamName,
                                  style: const TextStyle(color: Colors.white)),
                            ],
                          )),
                          DataCell(Text(standing.played.toString(),
                              style: const TextStyle(color: Colors.white))),
                          DataCell(Text(standing.win.toString(),
                              style: const TextStyle(color: Colors.white))),
                          DataCell(Text(standing.draw.toString(),
                              style: const TextStyle(color: Colors.white))),
                          DataCell(Text(standing.loss.toString(),
                              style: const TextStyle(color: Colors.white))),
                          DataCell(Text(standing.goalDifference.toString(),
                              style: const TextStyle(color: Colors.white))),
                          DataCell(Text(standing.points.toString(),
                              style: const TextStyle(color: Colors.red))),
                        ],
                      ),
                    )
                    .toList(),
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
