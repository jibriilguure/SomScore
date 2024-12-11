import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:somscore/international/api/endpoints.dart';

import '../../../../key.dart';
import 'fixture_model.dart';

class FixtureService {
  static const String apiUrl = ApiFootballEndpoints.getFixtures;
  static const String apiKey = Config.apiFootballApiKey;

  // Fetch fixtures for a given league and season
  Future<List<Fixture>> fetchFixtures(int leagueId, String season) async {
    // Open a Hive box for storing fixtures per league and season
    String boxName = 'fixtures_$leagueId\_$season';
    var fixtureBox = await Hive.openBox<Fixture>(boxName);
    var metadataBox =
        await Hive.openBox('metadata'); // Separate box for metadata

    // Check if the cache is valid or needs updating
    if (!_isCacheValid(metadataBox, leagueId, season)) {
      final response = await http.get(
        Uri.parse('$apiUrl?league=$leagueId&season=$season'),
        headers: {
          'X-RapidAPI-Key': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['response'];
        final List<Fixture> fixtures =
            data.map((json) => Fixture.fromJson(json)).toList();

        // Clear previous data in Hive and store the new data
        await fixtureBox.clear();
        for (var fixture in fixtures) {
          await fixtureBox.add(fixture);
        }

        // Update the cache metadata with the new fetch time and store league/season for validation
        await metadataBox.put(
            'lastFetchTime_$boxName', DateTime.now().toIso8601String());
        await metadataBox.put('lastFetchLeague_$boxName', leagueId);
        await metadataBox.put('lastFetchSeason_$boxName', season);

        return fixtures;
      } else {
        throw Exception('Failed to fetch fixtures');
      }
    } else {
      // Return cached data from Hive
      return fixtureBox.values.toList();
    }
  }

  // Check if cache is valid for the league and season (data fetched within last 1 day)
  bool _isCacheValid(Box metadataBox, int leagueId, String season) {
    String boxName = 'fixtures_$leagueId\_$season';
    final lastFetchTime = metadataBox.get('lastFetchTime_$boxName');
    final lastFetchLeague = metadataBox.get('lastFetchLeague_$boxName');
    final lastFetchSeason = metadataBox.get('lastFetchSeason_$boxName');

    // Cache is invalid if there is no record or the league/season has changed
    if (lastFetchTime == null ||
        lastFetchLeague != leagueId ||
        lastFetchSeason != season) {
      return false;
    }

    // Check if the cached data is older than 1 day
    final lastFetchDateTime = DateTime.parse(lastFetchTime);
    return DateTime.now().difference(lastFetchDateTime).inDays < 1;
  }
}
