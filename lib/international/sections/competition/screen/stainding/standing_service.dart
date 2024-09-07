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

  Future<Map<String, List<CupStanding>>> fetchCupStandings(
      int leagueId, String season) async {
    final cupBox =
        await Hive.openBox<CupStanding>('cupStandings_${leagueId}_$season');
    var metadataBox =
        await Hive.openBox('metadata'); // Store metadata like fetch time

    // Check if data is cached and the cache is valid
    if (cupBox.isNotEmpty && _isCacheValid(metadataBox, leagueId, season)) {
      // Return cached data
      Map<String, List<CupStanding>> cachedStandingsByGroup = {};

      for (var standing in cupBox.values) {
        if (!cachedStandingsByGroup.containsKey(standing.group)) {
          cachedStandingsByGroup[standing.group] = [];
        }
        cachedStandingsByGroup[standing.group]!.add(standing);
      }

      return cachedStandingsByGroup;
    }

    // If cache is invalid, fetch from API
    final response = await http.get(
      Uri.parse('$apiUrl?league=$leagueId&season=$season'),
      headers: {
        'X-RapidAPI-Key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['response'][0]['league']
          ['standings'] as List;
      final Map<String, List<CupStanding>> standingsByGroup = {};

      for (var groupStandings in data) {
        for (var standingJson in groupStandings) {
          final standing = CupStanding.fromJson(standingJson);
          if (!standingsByGroup.containsKey(standing.group)) {
            standingsByGroup[standing.group] = [];
          }
          standingsByGroup[standing.group]!.add(standing);
        }
      }

      // Clear previous data and store the new data in the Hive box
      await cupBox.clear();
      for (var group in standingsByGroup.keys) {
        for (var standing in standingsByGroup[group]!) {
          await cupBox.add(standing); // Save each standing in the box
        }
      }

      // Store the time of the fetch in metadata to track cache validity
      await metadataBox.put('lastFetchTime_${leagueId}_$season',
          DateTime.now().toIso8601String());

      return standingsByGroup;
    } else {
      throw Exception('Failed to fetch standings');
    }
  }
}
