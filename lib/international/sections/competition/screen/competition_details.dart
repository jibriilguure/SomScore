import 'package:flutter/material.dart';
import 'fixture_screen/FixturesScreen.dart';

import 'stainding/cup_standing_screen.dart';
import 'stainding/standing_screen.dart';
import 'sub-screens/top_scorers.dart';

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

  int _tabCount = 1; // Default tab count is at least 1 (for fixtures)

  @override
  void initState() {
    super.initState();
    // Fetch competition data and seasons from cache or API, with caching for 1 day
    futureCompetitionData = competitionService
        .fetchCompetitionWithSeasons(widget.competition.id, nDays: 1);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: futureCompetitionData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Text('Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red)),
            ),
          );
        } else if (snapshot.hasData) {
          final competitionData = snapshot.data!;
          seasons = competitionData['seasons'];

          final currentCompetition =
              competitionData['competition'] as Competition;

          // Automatically set the selected season to the current season
          selectedSeason ??= competitionData['currentSeason'];

          // Determine how many tabs are true (fixtures, standings, top_scorers)
          _tabCount = 1; // We always have Fixtures
          if (currentCompetition.standings) _tabCount++;
          if (currentCompetition.topScorers) _tabCount++;

          return DefaultTabController(
            length: _tabCount, // Dynamically set the tab length
            child: Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.black,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                title: _buildAppBarTitle(),
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
                bottom: TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.red,
                  tabs: _buildTabs(currentCompetition),
                ),
              ),
              body: TabBarView(
                children: _buildTabViews(currentCompetition),
              ),
            ),
          );
        } else {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child:
                  Text('No data found', style: TextStyle(color: Colors.white)),
            ),
          );
        }
      },
    );
  }

  // Build the tabs based on the available data (fixtures, standings, top_scorers)
  List<Tab> _buildTabs(Competition competition) {
    List<Tab> tabs = [const Tab(text: "Fixtures")]; // Fixtures is always there
    if (competition.standings) {
      tabs.add(const Tab(text: "Standings"));
    }
    if (competition.topScorers) {
      tabs.add(const Tab(text: "Top Scorers"));
    }
    return tabs;
  }

  // Build the TabViews based on the available data (fixtures, standings, top_scorers)
  List<Widget> _buildTabViews(Competition competition) {
    List<Widget> tabViews = [
      FixturesScreen(
          leagueId: competition.id,
          season:
              selectedSeason!), // Pass leagueId and season to FixturesScreen
    ]; // Fixtures is always there

    if (competition.standings) {
      if (competition.type == "Cup") {
        // Show cup standings if it's a cup competition
        tabViews.add(
          CupStandingsScreen(
            leagueId: competition.id,
            season:
                selectedSeason!, // Pass leagueId and season to CupStandingsScreen
          ),
        );
      } else {
        // Show league standings if it's a league competition
        tabViews.add(
          StandingsScreen(
            leagueId: competition.id,
            season:
                selectedSeason!, // Pass leagueId and season to StandingsScreen
          ),
        );
      }
    }

    if (competition.topScorers) {
      tabViews.add(TopScorersScreen(
        leagueId: competition.id,
        season: selectedSeason!,
      ));
    }

    return tabViews;
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
}
