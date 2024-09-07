import 'package:flutter/material.dart';
import 'cup_standing_model.dart';
import 'standing_service.dart';

class CupStandingsScreen extends StatefulWidget {
  final int leagueId;
  final String season;

  const CupStandingsScreen({
    Key? key,
    required this.leagueId,
    required this.season,
  }) : super(key: key);

  @override
  _CupStandingsScreenState createState() => _CupStandingsScreenState();
}

class _CupStandingsScreenState extends State<CupStandingsScreen> {
  late Future<Map<String, List<CupStanding>>> futureCupStandings;
  final standingService = StandingService();

  @override
  void initState() {
    super.initState();
    futureCupStandings =
        standingService.fetchCupStandings(widget.leagueId, widget.season);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<Map<String, List<CupStanding>>>(
        future: futureCupStandings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red)),
            );
          } else if (snapshot.hasData) {
            final standingsByGroup = snapshot.data!;

            return ListView(
              children: standingsByGroup.keys.map((group) {
                final standings = standingsByGroup[group]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        group, // Group Name
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 10, // Adjusted for closer alignment
                        columns: const <DataColumn>[
                          DataColumn(
                              label: Text('#',
                                  style: TextStyle(color: Colors.grey))),
                          DataColumn(
                              label: Text('Club',
                                  style: TextStyle(color: Colors.grey))),
                          DataColumn(
                              label: Text('PL',
                                  style: TextStyle(color: Colors.grey))),
                          DataColumn(
                              label: Text('W',
                                  style: TextStyle(color: Colors.grey))),
                          DataColumn(
                              label: Text('D',
                                  style: TextStyle(color: Colors.grey))),
                          DataColumn(
                              label: Text('L',
                                  style: TextStyle(color: Colors.grey))),
                          DataColumn(
                              label: Text('GD',
                                  style: TextStyle(color: Colors.grey))),
                          DataColumn(
                              label: Text('PTS',
                                  style: TextStyle(color: Colors.grey))),
                        ],
                        rows: standings.map((standing) {
                          return DataRow(cells: [
                            DataCell(Text(standing.rank.toString(),
                                style: const TextStyle(color: Colors.white))),
                            DataCell(Row(
                              children: [
                                Image.network(standing.teamLogo, width: 20),
                                const SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    standing.teamName,
                                    style: const TextStyle(color: Colors.white),
                                    overflow: TextOverflow
                                        .ellipsis, // Shorten long names
                                  ),
                                ),
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
                          ]);
                        }).toList(),
                      ),
                    ),
                  ],
                );
              }).toList(),
            );
          } else {
            return const Center(
                child: Text('No data found',
                    style: TextStyle(color: Colors.white)));
          }
        },
      ),
    );
  }
}
