import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:somscore/international/api/endpoints.dart';
import '../../../../key.dart';
import '../model/competition_model.dart';

class CompetitionService {
  static const String apiUrl = '${ApiFootballEndpoints.baseUrl}leagues';
  static const String apiKey = Config.apiFootballApiKey;

  // Desired league IDs to filter
  static const List<int> desiredLeagueIds = [39, 2, 15, 846];

  // Helper method to store the last fetch time
  Future<void> _storeLastFetchTime(Box box) async {
    await box.put('lastFetchTime', DateTime.now().toIso8601String());
  }

  // Method to check if cache is expired based on nDays
  bool _isCacheExpired(Box box, int nDays) {
    final lastFetchTime = box.get('lastFetchTime');
    if (lastFetchTime == null)
      return true; // Cache is expired if no last fetch time is found

    final lastFetchDateTime = DateTime.parse(lastFetchTime);
    final currentDate = DateTime.now();
    return currentDate.difference(lastFetchDateTime).inDays >= nDays;
  }

  Future<List<Competition>> fetchCompetitions({required int nDays}) async {
    // Open Hive box
    var box = await Hive.openBox<Competition>('competitions');

    // Get competitions from Hive
    List<Competition> competitions = getCompetitionsFromHive(box, nDays);

    if (competitions.isNotEmpty) {
      // If valid data is in Hive, return it
      return competitions;
    } else {
      // Otherwise, fetch new data from the API
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'X-RapidAPI-Key': apiKey,
          'X-RapidAPI-Host': 'v3.football.api-sports.io',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['response'];

        // Filter the data to include only the desired leagues
        final filteredData = data
            .where((json) => desiredLeagueIds.contains(json['league']['id']))
            .toList();

        competitions =
            filteredData.map((json) => Competition.fromJson(json)).toList();

        // Clear old data in the box
        await box.clear();

        // Store the fetched data in Hive using the new logic
        for (var competition in competitions) {
          var competitionToSave = {
            'id': competition.id,
            'name': competition.name,
            'type': competition.type,
            'logoUrl': competition.logoUrl,
            'countryName': competition.countryName,
            'countryCode': competition.countryCode,
            'fetchDate': competition.fetchDate.toIso8601String(),
            'events': competition.events,
            'lineups': competition.lineups,
            'statisticsFixtures': competition.statisticsFixtures,
            'statisticsPlayers': competition.statisticsPlayers,
            'standings': competition.standings,
            'players': competition.players,
            'topScorers': competition.topScorers,
            'topAssists': competition.topAssists,
            'topCards': competition.topCards,
            'injuries': competition.injuries,
            'predictions': competition.predictions,
            'odds': competition.odds,
          };
          await box.add(Competition.fromHive(competitionToSave));
        }

        // Store the last fetch time
        await _storeLastFetchTime(box);

        return competitions;
      } else {
        throw Exception('Failed to load competitions');
      }
    }
  }

  List<Competition> getCompetitionsFromHive(Box<Competition> box, int nDays) {
    List<Competition> competitions = box.values.toList();

    final currentDate = DateTime.now();
    return competitions.where((competition) {
      final difference = currentDate.difference(competition.fetchDate).inDays;
      return difference <= nDays;
    }).toList();
  }

  // Method to fetch specific competition data based on leagueId and season
  Future<Competition> fetchCompetitionBySeason(
      int leagueId, String season) async {
    final response = await http.get(
      Uri.parse('$apiUrl?id=$leagueId&season=$season'),
      headers: {
        'X-RapidAPI-Key': apiKey,
        'X-RapidAPI-Host': 'v3.football.api-sports.io',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['response'];
      if (data.isNotEmpty) {
        return Competition.fromJson(
            data[0]); // Return the first result for the selected season
      } else {
        throw Exception('No data found for the selected season.');
      }
    } else {
      throw Exception('Failed to load data for the season.');
    }
  }

  // Method to fetch competition data including seasons based on leagueId with caching logic
  Future<Map<String, dynamic>> fetchCompetitionWithSeasons(int leagueId,
      {required int nDays}) async {
    var box = await Hive.openBox('competition_seasons_$leagueId');

    // Get data from Hive, if available and within nDays
    if (!_isCacheExpired(box, nDays)) {
      final cachedData =
          box.get('competitionWithSeasons') as Map<dynamic, dynamic>?;

      // Cast it to the correct type Map<String, dynamic>
      if (cachedData != null) {
        return Map<String, dynamic>.from(cachedData);
      }
    }

    // Otherwise, fetch new data from API
    final response = await http.get(
      Uri.parse('$apiUrl?id=$leagueId'),
      headers: {
        'X-RapidAPI-Key': apiKey,
        'X-RapidAPI-Host': 'v3.football.api-sports.io',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          json.decode(response.body)['response'][0];
      List<dynamic> seasons = data['seasons'];

      // Extract seasons list and identify the current season
      String currentSeason = seasons
          .firstWhere((season) => season['current'] == true)['year']
          .toString();

      final competitionData = {
        'competition': Competition.fromJson(data),
        'seasons': seasons.map((s) => s['year'].toString()).toList(),
        'currentSeason': currentSeason,
      };

      // Cache the fetched competition data with seasons
      await box.put('competitionWithSeasons', competitionData);
      // Store the last fetch time
      await _storeLastFetchTime(box);

      return competitionData;
    } else {
      throw Exception('Failed to load data for the competition.');
    }
  }
}
