import 'dart:async'; // For Timer
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting and timezone conversion
import 'package:somscore/international/sections/competition/screen/matchdetails/events/match_event_screen.dart';
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
  FixtureMatchDetail? fixtureData;
  final matchDetailsService = MatchDetailsService();
  Timer? countdownTimer;
  Timer? refreshTimer; // Timer to refresh live matches every 15 seconds
  String countdownText = ''; // This will store the countdown string
  DateTime? matchDate; // To store the match date

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchMatchData(); // Initial data fetch

    // Schedule the countdown updates every second
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (matchDate != null) {
        _updateCountdown();
      }
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel(); // Cancel the timer when the widget is disposed
    refreshTimer?.cancel(); // Cancel the refresh timer
    _tabController.dispose();
    super.dispose();
  }

  // Fetch match data and handle periodic fetching for live matches
  Future<void> _fetchMatchData() async {
    fixtureData = await matchDetailsService.fetchMatchDetails(widget.fixtureId);
    if (fixtureData != null &&
        matchDetailsService.isMatchInProgress(fixtureData!.status.short)) {
      // If match is live, refresh the data every 15 seconds
      refreshTimer?.cancel();
      refreshTimer = Timer.periodic(const Duration(seconds: 15), (_) {
        _fetchMatchData();
      });
    }
    setState(() {}); // Refresh UI with new data
  }

  // Function to update the countdown every second
  void _updateCountdown() {
    final now = DateTime.now();
    final duration = matchDate!.difference(now);

    if (duration.isNegative) {
      countdownText = 'Match started';
    } else {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      final seconds = duration.inSeconds % 60;
      setState(() {
        countdownText = '${hours.toString().padLeft(2, '0')}:'
            '${minutes.toString().padLeft(2, '0')}:'
            '${seconds.toString().padLeft(2, '0')}';
      });
    }
  }

  // Function to format the fixture date
  String formatFixtureDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date).toUtc();
      return DateFormat('h:mm a').format(parsedDate.toLocal());
    } catch (e) {
      print('Error parsing date: $e');
      return 'Invalid Date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Column(
          children: [
            Text("Match Details", style: TextStyle(color: Colors.white)),
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
      body: fixtureData == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                                  fixtureData?.teamsMatch.home.logo ?? '',
                                  Icons.shield,
                                ),
                                Text(
                                  fixtureData?.teamsMatch.home.name ?? '',
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

                            // Middle score or countdown
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      fixtureData?.status.short == 'NS'
                                          ? countdownText // Show countdown
                                          : '${fixtureData?.goals.home ?? 0} - ${fixtureData?.goals.away ?? 0}', // Show score
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                if (fixtureData?.status.short != 'NS') ...[
                                  Column(
                                    children: [
                                      Text(
                                        fixtureData?.status.short ?? '',
                                        style: const TextStyle(
                                            color: Colors.green, fontSize: 14),
                                      ),
                                      Text(
                                        '${fixtureData?.status.elapsed?.toString() ?? ''}\'',
                                        style: const TextStyle(
                                            color: Colors.green, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ]
                              ],
                            ),

                            // Right team logo and goal scorers
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildTeamLogo(
                                  fixtureData?.teamsMatch.away.logo ?? '',
                                  Icons.shield,
                                ),
                                Text(
                                  fixtureData?.teamsMatch.away.name ?? '',
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
                      MatchEventScreen(
                        fixtureId: widget.fixtureId,
                        homeTeam: fixtureData!.teamsMatch.home.id,
                      ),
                      _buildTabContent('Line Up'),
                      _buildTabContent('H2H'),
                      _buildTabContent('Standings'),
                    ],
                  ),
                ),
              ],
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
