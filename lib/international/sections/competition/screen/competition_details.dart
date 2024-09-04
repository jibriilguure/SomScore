import 'package:flutter/material.dart';
import '../model/competition_model.dart';
import '../services/competition_service.dart';

class CompetitionDetailScreen extends StatefulWidget {
  final Competition competition;
  const CompetitionDetailScreen({super.key, required this.competition});

  @override
  _CompetitionDetailScreenState createState() =>
      _CompetitionDetailScreenState();
}

class _CompetitionDetailScreenState extends State<CompetitionDetailScreen> {
  late Future<Map<String, dynamic>> futureCompetitionData;
  List<String> seasons = [];
  String? selectedSeason; // No default value, will be set dynamically
  final competitionService = CompetitionService();

  @override
  void initState() {
    super.initState();
    // Fetch competition data and seasons from cache or API, with caching for 1 day
    futureCompetitionData = competitionService
        .fetchCompetitionWithSeasons(widget.competition.id, nDays: 1);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Fixtures, Standings, Top Scorers
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: FutureBuilder<Map<String, dynamic>>(
            future: futureCompetitionData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red));
              } else if (snapshot.hasData) {
                final competitionData = snapshot.data!;
                seasons = competitionData['seasons'];

                // Automatically set the selected season to the current season
                selectedSeason ??= competitionData['currentSeason'];

                return _buildAppBarTitle();
              } else {
                return const Text('No data',
                    style: TextStyle(color: Colors.white));
              }
            },
          ),
          centerTitle: true, // Ensure the title is centered
          actions: [
            IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.star_border, color: Colors.white),
              onPressed: () {},
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.red,
            tabs: [
              Tab(text: "Fixtures"),
              Tab(text: "Standings"),
              Tab(text: "Top Scorers"),
            ],
          ),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: futureCompetitionData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.white)));
            } else if (snapshot.hasData) {
              return TabBarView(
                children: [
                  _buildFixturesTab(),
                  _buildStandingsTab(),
                  _buildTopScorersTab(),
                ],
              );
            } else {
              return const Center(
                  child: Text('No data found',
                      style: TextStyle(color: Colors.white)));
            }
          },
        ),
      ),
    );
  }

  Widget _buildAppBarTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              widget.competition.logoUrl,
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 8),
            DropdownButton<String>(
              value: selectedSeason,
              dropdownColor: Colors.black,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              underline: const SizedBox(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedSeason = newValue!;
                  // Fetch data for the new season
                  futureCompetitionData = competitionService
                      .fetchCompetitionWithSeasons(widget.competition.id,
                          nDays: 1);
                });
              },
              items: seasons.map<DropdownMenuItem<String>>((String season) {
                return DropdownMenuItem<String>(
                  value: season,
                  child: Text(
                    season,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          widget.competition.name,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        Text(
          widget.competition.countryName,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildFixturesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (context, index) {
        return _buildMatchItem(
            "Home Team $index", "Away Team $index", "2", "1", false, "FT 15/4");
      },
    );
  }

  Widget _buildMatchItem(String homeTeam, String awayTeam, String homeScore,
      String awayScore, bool isLive, String status) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(status,
                  style: TextStyle(color: isLive ? Colors.green : Colors.grey)),
              const SizedBox(width: 8),
              Text(homeTeam, style: const TextStyle(color: Colors.white)),
            ],
          ),
          Text("$homeScore - $awayScore",
              style: const TextStyle(color: Colors.white, fontSize: 16)),
          Text(awayTeam, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildStandingsTab() {
    return const Center(
      child: Text('Standings', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildTopScorersTab() {
    return const Center(
      child: Text('Top Scorers', style: TextStyle(color: Colors.white)),
    );
  }
}
