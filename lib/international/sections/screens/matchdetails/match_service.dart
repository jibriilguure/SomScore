import 'dart:convert';
import 'dart:async'; // For Timer functionality
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:somscore/international/api/endpoints.dart';
import 'package:somscore/key.dart';
import 'model/fixture_model.dart';

class MatchDetailsService {
  final String apiUrl = ApiFootballEndpoints.getFixtures;
  final String apiKey = Config.apiFootballApiKey;
  final int refreshIntervalInSeconds =
      15; // Set fetch interval for live matches

  Timer? _timer; // To manage periodic fetching

  // Function to check if the cached data is still valid based on the status
  bool isCacheValid(Box metadataBox, String matchStatus) {
    final lastFetchTime = metadataBox.get('lastFetchTime');
    if (lastFetchTime == null) return false;

    final lastFetchDateTime = DateTime.parse(lastFetchTime);
    final currentTime = DateTime.now();

    // If match is in progress, cache for only 1 minute
    if (isMatchInProgress(matchStatus)) {
      return currentTime.difference(lastFetchDateTime).inMinutes < 1;
    }

    // If match is finished, cache for 24 hours
    if (isMatchFinished(matchStatus)) {
      return currentTime.difference(lastFetchDateTime).inHours < 24;
    }

    // For other statuses, cache for 1 hour
    return currentTime.difference(lastFetchDateTime).inHours < 1;
  }

  // Store last fetch time in metadata
  Future<void> _storeLastFetchTime(Box metadataBox) async {
    await metadataBox.put('lastFetchTime', DateTime.now().toIso8601String());
  }

  // Check if the match status indicates the match is finished
  bool isMatchFinished(String status) {
    const finishedStatuses = ['FT', 'AET', 'PEN'];
    return finishedStatuses.contains(status);
  }

  // Check if the match status indicates the match is in progress
  bool isMatchInProgress(String status) {
    const inProgressStatuses = ['1H', '2H', 'ET', 'BT', 'P'];
    return inProgressStatuses.contains(status);
  }

  // Check if the match start time is within the next 10 minutes
  bool isMatchStartingSoon(String matchDate) {
    final now = DateTime.now().toUtc();
    final matchStartTime = DateTime.parse(matchDate).toUtc();
    return matchStartTime.isAfter(now) &&
        matchStartTime.difference(now).inMinutes <= 10;
  }

  // Fetch match details periodically for matches in progress
  void startPeriodicFetching(int matchId) {
    _timer?.cancel(); // Cancel any existing timer

    _timer = Timer.periodic(Duration(seconds: refreshIntervalInSeconds),
        (timer) async {
      await fetchMatchDetails(matchId);
    });
  }

  // Stop periodic fetching when the match finishes
  void stopPeriodicFetching() {
    _timer?.cancel();
  }

  // Fetch match details from the API or return cached data
  Future<FixtureMatchDetail?> fetchMatchDetails(int matchId) async {
    var matchBox =
        await Hive.openBox<FixtureMatchDetail>('matchDetails_$matchId');
    var metadataBox = await Hive.openBox('metadata_$matchId');

    // Get current match status and date from the cache (if available)
    final matchStatus = matchBox.get(0)?.status.short ?? '';
    final matchDate = matchBox.get(0)?.date ?? '';

    // Check if cached data is available and valid based on match status
    if (matchBox.isNotEmpty && isCacheValid(metadataBox, matchStatus)) {
      print('Returning cached match details');
      return matchBox.get(0);
    }

    // If cache is invalid, fetch from the API
    final response = await http.get(
      Uri.parse('$apiUrl?id=$matchId'),
      headers: {
        'X-RapidAPI-Key': apiKey,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('API Response: $data');

      if (data['response'] == null || data['response'].isEmpty) {
        throw Exception('No data found in API response');
      }

      final matchData = data['response'][0];
      final matchDetails = FixtureMatchDetail.fromJson(matchData);

      // Cache the data based on match status
      if (isMatchFinished(matchDetails.status.short)) {
        await matchBox.clear(); // Clear old data
        await matchBox.put(0, matchDetails); // Store new data
        stopPeriodicFetching(); // Stop fetching if match is finished
      } else if (isMatchInProgress(matchDetails.status.short) ||
          (matchDetails.status.short == 'NS' &&
              isMatchStartingSoon(matchDetails.date))) {
        // If the match is starting soon (within 10 minutes), treat it as in progress
        await matchBox.clear(); // Clear old data
        await matchBox.put(0, matchDetails); // Store new data
        startPeriodicFetching(
            matchId); // Start periodic fetching if match is in progress
      } else {
        // Cache other match statuses for 1 hour
        await matchBox.clear();
        await matchBox.put(0, matchDetails);
        stopPeriodicFetching(); // Stop periodic fetching if not in progress
      }

      // Store the fetch time in metadata
      await _storeLastFetchTime(metadataBox);

      return matchDetails;
    } else {
      throw Exception('Failed to fetch match details from API');
    }
  }
}
