import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:somscore/key.dart';
import 'model/fixture_model.dart';

class MatchDetailsService {
  final String apiUrl = 'https://v3.football.api-sports.io/fixtures';
  final String apiKey = Config.apiFootballApiKey;

  // Function to check if the cached data is valid
  bool _isCacheValid(Box metadataBox) {
    final lastFetchTime = metadataBox.get('lastFetchTime');
    if (lastFetchTime == null) return false;

    final lastFetchDateTime = DateTime.parse(lastFetchTime);
    final currentTime = DateTime.now();
    // Cache validity is 1 day
    return currentTime.difference(lastFetchDateTime).inHours < 24;
  }

  // Store last fetch time in metadata
  Future<void> _storeLastFetchTime(Box metadataBox) async {
    await metadataBox.put('lastFetchTime', DateTime.now().toIso8601String());
  }

  // Fetch match details from API or return cached data
  Future<FixtureMatchDetail?> fetchMatchDetails(int matchId) async {
    var matchBox =
        await Hive.openBox<FixtureMatchDetail>('matchDetails_$matchId');
    var metadataBox = await Hive.openBox('metadata_$matchId');

    // Check if we have valid cached data and return it if valid
    if (matchBox.isNotEmpty && _isCacheValid(metadataBox)) {
      return matchBox.get(0); // Return the cached data
    }

    // If cache is invalid, fetch from the API
    try {
      final response = await http.get(
        Uri.parse('$apiUrl?id=$matchId'),
        headers: {
          'X-RapidAPI-Key': apiKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('API Response: $data'); // Debugging the API response

        if (data['response'] == null || data['response'].isEmpty) {
          throw Exception('No data found in API response');
        }

        final matchData =
            data['response'][0]; // Get the first item in the response
        final matchDetails = FixtureMatchDetail.fromJson(
            matchData); // Pass the entire JSON map to the model

        // Clear old data in Hive and store new data
        await matchBox.clear();
        await matchBox.put(0, matchDetails);

        // Update last fetch time in metadata
        await _storeLastFetchTime(metadataBox);

        return matchDetails;
      } else {
        throw Exception('Failed to fetch match details from API');
      }
    } catch (error) {
      print('Error occurred while fetching match details: $error');
      return null;
    }
  }
}
