import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../events/match_event_screen.dart';
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
  Timer? refreshTimer;
  String countdownText = '';
  DateTime? matchDate;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchMatchData(); // Initial data fetch

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (matchDate != null) {
        _updateCountdown();
      }
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    refreshTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchMatchData() async {
    fixtureData = await matchDetailsService.fetchMatchDetails(widget.fixtureId);
    if (fixtureData != null &&
        matchDetailsService.isMatchInProgress(fixtureData!.status.short)) {
      refreshTimer?.cancel();
      refreshTimer = Timer.periodic(const Duration(seconds: 15), (_) {
        _fetchMatchData();
      });
    }
    setState(() {}); // Refresh UI with new data
  }

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
      ),
      body: fixtureData == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left team logo
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildTeamLogo(
                              fixtureData?.teamsMatch.home.logo ?? '',
                              Icons.shield,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              fixtureData?.teamsMatch.home.name ?? '',
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        // Center: time or countdown
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _getMatchStatus(fixtureData!.status.short),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (fixtureData?.status.short == 'NS')
                              Text(
                                countdownText,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                          ],
                        ),
                        // Right team logo
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildTeamLogo(
                              fixtureData?.teamsMatch.away.logo ?? '',
                              Icons.shield,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              fixtureData?.teamsMatch.away.name ?? '',
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
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
        width: 50,
        height: 50,
        errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          return Icon(
            fallbackIcon,
            color: Colors.grey,
            size: 50,
          );
        },
        fit: BoxFit.cover,
      ),
    );
  }

  String _getMatchStatus(String status) {
    if (status == 'NS') {
      return DateFormat('h:mm a')
          .format(DateTime.parse(fixtureData!.date).toLocal());
    } else if (status == '1H' ||
        status == '2H' ||
        status == 'ET' ||
        status == 'BT' ||
        status == 'P') {
      return status; // Match is in progress, show the current phase.
    } else if (status == 'FT' || status == 'AET' || status == 'PEN') {
      return 'Match Ended'; // Full-time or penalties.
    } else {
      return 'Unknown Status'; // Fallback for any other status.
    }
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
