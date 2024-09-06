import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:somscore/international/api/endpoints.dart';
import 'package:somscore/key.dart';

import 'model/top_scorer_model.dart'; // Import the player model

class TopScorersService {
  static const String apiUrl = ApiFootballEndpoints.getTopScorers;
  static const String apiKey = Config.apiFootballApiKey;

  // Fetch top scorers for a given league and season
  Future<List<Player>> fetchTopScorers(int leagueId, String season) async {
    // Open a unique Hive box for each league by appending the leagueId to the box name
    var playerBox = await Hive.openBox<Player>('topScorers_$leagueId');
    var metadataBox = await Hive.openBox(
        'metadata_$leagueId'); // Separate metadata box per league

    // Check if the cache is valid or needs updating
    if (!_isCacheValid(metadataBox, season)) {
      final response = await http.get(
        Uri.parse('$apiUrl?league=$leagueId&season=$season'),
        headers: {
          'X-RapidAPI-Key': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['response'];
        final List<Player> players =
            data.map((json) => Player.fromJson(json)).toList();

        // Clear previous data in the specific league box and store the new data
        await playerBox.clear();
        for (var player in players) {
          await playerBox.add(player);
        }

        // Update the cache metadata with the new fetch time and store the season for validation
        await metadataBox.put(
            'lastFetchTime', DateTime.now().toIso8601String());
        await metadataBox.put('lastFetchSeason', season);

        return players;
      } else {
        throw Exception('Failed to fetch top scorers');
      }
    } else {
      // Return cached data from the specific league's Hive box
      return playerBox.values.toList();
    }
  }

  // Validate if the cache is still valid for the league's metadata
  bool _isCacheValid(Box metadataBox, String season) {
    final lastFetchTime = metadataBox.get('lastFetchTime');
    final lastFetchSeason = metadataBox.get('lastFetchSeason');

    // Cache is invalid if there is no record or the season has changed
    if (lastFetchTime == null || lastFetchSeason != season) {
      return false;
    }

    // Check if the cached data is older than 1 day
    final lastFetchDateTime = DateTime.parse(lastFetchTime);
    return DateTime.now().difference(lastFetchDateTime).inDays < 1;
  }
}
