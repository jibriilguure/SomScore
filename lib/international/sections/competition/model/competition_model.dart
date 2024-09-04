import 'package:hive/hive.dart';

part 'competition_model.g.dart'; // This part directive is necessary

@HiveType(typeId: 0)
class Competition extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String type; // This will differentiate between League and Cup

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

  // Initialize fields
  factory Competition.fromJson(Map<String, dynamic> json) {
    final coverage = json['seasons'].last['coverage'];

    return Competition(
      id: json['league']['id'],
      name: json['league']['name'],
      type: json['league']['type'],
      logoUrl: json['league']['logo'],
      countryName: json['country']['name'],
      countryCode: json['country']['code'],
      fetchDate: DateTime.now(),
      events: coverage['fixtures']['events'],
      lineups: coverage['fixtures']['lineups'],
      statisticsFixtures: coverage['fixtures']['statistics_fixtures'],
      statisticsPlayers: coverage['fixtures']['statistics_players'],
      standings: coverage['standings'],
      players: coverage['players'],
      topScorers: coverage['top_scorers'],
      topAssists: coverage['top_assists'],
      topCards: coverage['top_cards'],
      injuries: coverage['injuries'],
      predictions: coverage['predictions'],
      odds: coverage['odds'],
    );
  }

  // Parse JSON
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
}
