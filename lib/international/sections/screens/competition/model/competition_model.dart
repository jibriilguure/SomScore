import 'package:hive/hive.dart';

part 'competition_model.g.dart'; // This part directive is necessary

@HiveType(typeId: 0)
class Competition extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String type; // League or Cup

  @HiveField(3)
  final String logoUrl;

  @HiveField(4)
  final String countryName;

  @HiveField(5)
  final String? countryCode;

  @HiveField(6)
  final DateTime fetchDate;

  // Coverage fields
  @HiveField(7)
  final bool events;

  @HiveField(8)
  final bool lineups;

  @HiveField(9)
  final bool statisticsFixtures;

  @HiveField(10)
  final bool statisticsPlayers;

  @HiveField(11)
  final bool standings;

  @HiveField(12)
  final bool players;

  @HiveField(13)
  final bool topScorers;

  @HiveField(14)
  final bool topAssists;

  @HiveField(15)
  final bool topCards;

  @HiveField(16)
  final bool injuries;

  @HiveField(17)
  final bool predictions;

  @HiveField(18)
  final bool odds;

  Competition({
    required this.id,
    required this.name,
    required this.type,
    required this.logoUrl,
    required this.countryName,
    this.countryCode,
    required this.fetchDate,
    required this.events,
    required this.lineups,
    required this.statisticsFixtures,
    required this.statisticsPlayers,
    required this.standings,
    required this.players,
    required this.topScorers,
    required this.topAssists,
    required this.topCards,
    required this.injuries,
    required this.predictions,
    required this.odds,
  });

  // Initialize fields from API response (assumes data has seasons coverage)
  factory Competition.fromJson(Map<String, dynamic> json) {
    // Get the most recent season to extract coverage info
    final recentSeason = json['seasons'].last['coverage'];

    return Competition(
      id: json['league']['id'],
      name: json['league']['name'],
      type: json['league']['type'],
      logoUrl: json['league']['logo'],
      countryName: json['country']['name'],
      countryCode: json['country']['code'],
      fetchDate: DateTime.now(), // Assign current fetch time
      events: recentSeason['fixtures']['events'],
      lineups: recentSeason['fixtures']['lineups'],
      statisticsFixtures: recentSeason['fixtures']['statistics_fixtures'],
      statisticsPlayers: recentSeason['fixtures']['statistics_players'],
      standings: recentSeason['standings'],
      players: recentSeason['players'],
      topScorers: recentSeason['top_scorers'],
      topAssists: recentSeason['top_assists'],
      topCards: recentSeason['top_cards'],
      injuries: recentSeason['injuries'],
      predictions: recentSeason['predictions'],
      odds: recentSeason['odds'],
    );
  }

  // Parse JSON from Hive format (stored in Hive with the custom adapter)
  factory Competition.fromHive(Map<String, dynamic> hiveData) {
    return Competition(
      id: hiveData['id'],
      name: hiveData['name'],
      type: hiveData['type'],
      logoUrl: hiveData['logoUrl'],
      countryName: hiveData['countryName'],
      countryCode: hiveData['countryCode'],
      fetchDate: DateTime.parse(hiveData['fetchDate']),
      events: hiveData['events'],
      lineups: hiveData['lineups'],
      statisticsFixtures: hiveData['statisticsFixtures'],
      statisticsPlayers: hiveData['statisticsPlayers'],
      standings: hiveData['standings'],
      players: hiveData['players'],
      topScorers: hiveData['topScorers'],
      topAssists: hiveData['topAssists'],
      topCards: hiveData['topCards'],
      injuries: hiveData['injuries'],
      predictions: hiveData['predictions'],
      odds: hiveData['odds'],
    );
  }

  // Convert Competition instance to a format that Hive can store
  Map<String, dynamic> toHive() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'logoUrl': logoUrl,
      'countryName': countryName,
      'countryCode': countryCode,
      'fetchDate': fetchDate.toIso8601String(),
      'events': events,
      'lineups': lineups,
      'statisticsFixtures': statisticsFixtures,
      'statisticsPlayers': statisticsPlayers,
      'standings': standings,
      'players': players,
      'topScorers': topScorers,
      'topAssists': topAssists,
      'topCards': topCards,
      'injuries': injuries,
      'predictions': predictions,
      'odds': odds,
    };
  }
}
