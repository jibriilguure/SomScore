import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:somscore/key.dart'; // Replace with your actual config file path
import 'model/fixture_model.dart';

class MatchDetailsService {
  final String apiUrl = 'https://v3.football.api-sports.io/fixtures';
  final String apiKey = Config.apiFootballApiKey;

  // Function to check if cached data is still valid
  bool _isCacheValid(Box metadataBox, String status) {
    final lastFetchTime = metadataBox.get('lastFetchTime');
    if (lastFetchTime == null) return false;

    final lastFetchDateTime = DateTime.parse(lastFetchTime);
    final currentTime = DateTime.now();

    if (status == 'FT') {
      return currentTime.difference(lastFetchDateTime).inHours < 24;
    } else {
      return currentTime.difference(lastFetchDateTime).inMinutes < 1;
    }
  }

  // Store last fetch time in metadata
  Future<void> _storeLastFetchTime(Box metadataBox) async {
    await metadataBox.put('lastFetchTime', DateTime.now().toIso8601String());
  }

  // Fetch match details from API or return cached data
  Future<FixtureMatchDetail?> fetchMatchDetails(
      int matchId, String status) async {
    var matchBox =
        await Hive.openBox<FixtureMatchDetail>('matchDetails_$matchId');
    var metadataBox = await Hive.openBox('metadata_$matchId');

    // Check if we have valid cached data
    if (matchBox.isNotEmpty && _isCacheValid(metadataBox, status)) {
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

      // Debug: Print the response to inspect the structure
      print('API Response: $data');

      if (data['response'] == null || data['response'].isEmpty) {
        throw Exception('No data found in API response');
      }

      final matchData = data['response'][0];

      // Parse the JSON response into the model
      final matchDetails = FixtureMatchDetail.fromJson(matchData);

      // Clear old data in Hive and store new data
      await matchBox.clear();
      await matchBox.put(0, matchDetails);

      // Update last fetch time in metadata
      await _storeLastFetchTime(metadataBox);

      return matchDetails;
    } else {
      throw Exception('Failed to fetch match details from API');
    }
  }
}
