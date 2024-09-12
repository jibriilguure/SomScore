import 'package:flutter/material.dart';
import 'package:somscore/international/sections/competition/screen/matchdetails/model/fixture_model.dart';
import 'match_service.dart'; // Import your service

class MatchDetailScreen extends StatefulWidget {
  final int fixtureId; // Fixture ID passed to the screen
  final String status; // Match status (e.g., FT, Live, etc.)

  const MatchDetailScreen({
    Key? key,
    required this.fixtureId,
    required this.status,
  }) : super(key: key);

  @override
  _MatchDetailScreenState createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<FixtureMatchDetail?> futureFixture;

  final matchDetailsService = MatchDetailsService(); // Initialize the service

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Fetch fixture data using the service and fixtureId passed as a parameter
    futureFixture =
        matchDetailsService.fetchMatchDetails(widget.fixtureId, widget.status);

    // Debugging information
    print('Fetching match details for fixtureId: ${widget.fixtureId}');
    print('Match status: ${widget.status}');
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
            Text(
              "Premier League",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Today",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
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
          print(
              'Connection state: ${snapshot.connectionState}'); // Debugging connection state

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error occurred: ${snapshot.error}'); // Debugging errors
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData) {
            print('No match data found'); // Debugging when no data found
            return const Center(
              child: Text(
                'No match data found',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            final fixture = snapshot.data;

            // Debugging fetched data
            print(
                'Match details fetched: ${fixture?.teamsMatch.home.name} vs ${fixture?.teamsMatch.away.name}');
            print('Score: ${fixture?.goals.home} - ${fixture?.goals.away}');
            print('Venue: ${fixture?.venue.name}, ${fixture?.venue.city}');
            print(
                'Status: ${fixture?.status.short}, Elapsed time: ${fixture?.status.elapsed}');

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
                                  '${fixture?.goals.home} - ${fixture?.goals.away}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${fixture?.status.elapsed ?? ''}\' ${widget.status}',
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
                    Tab(text: 'H2H'),
                    Tab(text: 'Standings'),
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
          print(
              'Error loading logo: $exception'); // Debugging image load errors
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
