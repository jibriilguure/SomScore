import 'package:flutter/material.dart';
import 'model/fixture_model.dart';
import 'match_service.dart';

class MatchDetailScreen extends StatefulWidget {
  final int fixtureId;

  const MatchDetailScreen({
    Key? key,
    required this.fixtureId,
  }) : super(key: key);

  @override
  _MatchDetailScreenState createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<FixtureMatchDetail?> futureFixture;
  final matchDetailsService = MatchDetailsService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    futureFixture = matchDetailsService.fetchMatchDetails(widget.fixtureId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Column(
          children: [
            Text("Match Details ", style: TextStyle(color: Colors.white)),
          ],
        ),
        centerTitle: true,
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
      ),
      body: FutureBuilder<FixtureMatchDetail?>(
        future: futureFixture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'No match data found',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            final fixture = snapshot.data;

            // Ensure status is safely handled and displayed
            final String statusText = fixture?.status.short ?? 'N/A';
            final String elapsedText =
                fixture?.status.elapsed?.toString() ?? '';

            return Column(
              children: [
                // Score section
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left team logo and goal scorers
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildTeamLogo(
                                  fixture?.teamsMatch.home.logo ?? '',
                                  Icons.shield,
                                ),
                                Text(
                                  fixture?.teamsMatch.home.name ?? '',
                                  style: const TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Goals',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),

                            // Middle score and time
                            Column(
                              children: [
                                Text(
                                  '${fixture?.goals.home ?? 0} - ${fixture?.goals.away ?? 0}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '$elapsedText\' $statusText',
                                  style: const TextStyle(
                                      color: Colors.green, fontSize: 14),
                                ),
                              ],
                            ),

                            // Right team logo and goal scorers
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildTeamLogo(
                                  fixture?.teamsMatch.away.logo ?? '',
                                  Icons.shield,
                                ),
                                Text(
                                  fixture?.teamsMatch.away.name ?? '',
                                  style: const TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Goals',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Tab Bar section
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.red,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(text: 'Summary'),
                    Tab(text: 'Line Up'),
                    Tab(text: 'Standings'),
                    Tab(text: 'H2H'),
                  ],
                ),
                // Tab Bar View for the selected tab content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTabContent('Summary'),
                      _buildTabContent('Line Up'),
                      _buildTabContent('H2H'),
                      _buildTabContent('Standings'),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildTeamLogo(String logoUrl, IconData fallbackIcon) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.network(
        logoUrl,
        width: 40,
        height: 40,
        errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          print('Error loading logo: $exception');
          return Icon(
            fallbackIcon,
            color: Colors.grey,
            size: 40,
          );
        },
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildTabContent(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
