import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:somscore/key.dart';
import 'model/fixture_model.dart';

class MatchDetailsService {
  final String apiUrl = 'https://v3.football.api-sports.io/fixtures';
  final String apiKey = Config.apiFootballApiKey;

  // Fetch match details from API
  Future<FixtureMatchDetail?> fetchMatchDetails(int matchId) async {
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

        final matchData = data['response'][0];
        final matchDetails = FixtureMatchDetail.fromJson(matchData);
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
