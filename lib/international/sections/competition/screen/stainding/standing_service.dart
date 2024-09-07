import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:somscore/international/api/endpoints.dart';
import 'package:somscore/key.dart';
import 'league_standing_model.dart';
import 'cup_standing_model.dart';

class StandingService {
  static const String apiUrl = ApiFootballEndpoints.getStanding;
  static const String apiKey = Config.apiFootballApiKey;

  // Function to check if the cache is still valid (e.g., data is less than a day old)
  bool _isCacheValid(Box metadataBox, int leagueId, String season) {
    final lastFetchTime = metadataBox.get('lastFetchTime_${leagueId}_$season');
    if (lastFetchTime == null) return false;

    final lastFetchDateTime = DateTime.parse(lastFetchTime);
    return DateTime.now().difference(lastFetchDateTime).inDays <
        1; // Valid for 1 day
  }

  Future<List<LeagueStanding>> fetchLeagueStandings(
      int leagueId, String season) async {
    var leagueBox = await Hive.openBox<LeagueStanding>(
        'leagueStandings_${leagueId}_$season');
    var metadataBox =
        await Hive.openBox('metadata'); // Store metadata like fetch time

    // Check if data is cached and the cache is valid
    if (leagueBox.isNotEmpty && _isCacheValid(metadataBox, leagueId, season)) {
      // Return cached data
      return leagueBox.values.toList();
    }

    // If cache is invalid, fetch from API
    final response = await http.get(
      Uri.parse('$apiUrl?league=$leagueId&season=$season'),
      headers: {
        'X-RapidAPI-Key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['response'] != null && data['response'].isNotEmpty) {
        final standingsData = data['response'][0]['league']['standings'][0];

        final List<LeagueStanding> standings = standingsData
            .map<LeagueStanding>((json) => LeagueStanding.fromJson(json))
            .toList();

        // Clear previous data and store the new data in the Hive box
        await leagueBox.clear();
        for (var standing in standings) {
          await leagueBox.add(standing);
        }

        // Store the time of the fetch in metadata to track cache validity
        await metadataBox.put('lastFetchTime_${leagueId}_$season',
            DateTime.now().toIso8601String());

        return standings;
      } else {
        throw Exception('No standings data found in the API response.');
      }
    } else {
      throw Exception('Failed to fetch standings from API.');
    }
  }

  Future<List<CupStanding>> fetchCupStandings(
      int leagueId, String season) async {
    var cupBox =
        await Hive.openBox<CupStanding>('cupStandings_$leagueId$season');
    var metadataBox =
        await Hive.openBox('metadata'); // Store metadata like fetch time

    // Check if data is cached and the cache is valid
    if (cupBox.isNotEmpty && _isCacheValid(metadataBox, leagueId, season)) {
      // Return cached data
      return cupBox.values.toList();
    }

    // If cache is invalid, fetch from API
    final response = await http.get(
      Uri.parse('$apiUrl?league=$leagueId&season=$season'),
      headers: {
        'X-RapidAPI-Key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['response'];
      final List<CupStanding> standings =
          data.map((json) => CupStanding.fromJson(json)).toList();

      // Clear previous data and store the new data in the Hive box
      await cupBox.clear();
      for (var standing in standings) {
        await cupBox.add(standing);
      }

      // Store the time of the fetch in metadata to track cache validity
      await metadataBox.put('lastFetchTime_${leagueId}_$season',
          DateTime.now().toIso8601String());

      return standings;
    } else {
      throw Exception('Failed to fetch cup standings');
    }
  }
}
