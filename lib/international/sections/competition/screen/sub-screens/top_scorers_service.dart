import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:somscore/key.dart';

import 'model/top_scorer_model.dart'; // Import the player model

class TopScorersService {
  static const String apiUrl =
      'https://v3.football.api-sports.io/players/topscorers';
  static const String apiKey = Config.apiFootballApiKey;
  Future<List<Player>> fetchTopScorers(int leagueId, String season) async {
    var playerBox = await Hive.openBox<Player>('topScorers');
    var metadataBox =
        await Hive.openBox('metadata'); // Separate box for metadata

    // Check if the cache is expired (data older than 1 day)
    if (!_isCacheValid(metadataBox)) {
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

        // Store new data in Hive and update cache time
        await playerBox.clear();
        for (var player in players) {
          await playerBox.add(player);
        }
        await metadataBox.put(
            'lastFetchTime',
            DateTime.now()
                .toIso8601String()); // Store fetch time in the metadata box

        return players;
      } else {
        throw Exception('Failed to fetch top scorers');
      }
    } else {
      // Return cached data from Hive
      return playerBox.values.toList();
    }
  }

  // Check if cache is valid (data fetched within last 1 day)
  bool _isCacheValid(Box metadataBox) {
    final lastFetchTime = metadataBox.get('lastFetchTime');
    if (lastFetchTime == null) return false;

    final lastFetchDateTime = DateTime.parse(lastFetchTime);
    return DateTime.now().difference(lastFetchDateTime).inDays < 1;
  }
}
