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
}
