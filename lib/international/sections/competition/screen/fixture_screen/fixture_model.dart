import 'package:hive/hive.dart';

part 'fixture_model.g.dart'; // For Hive type generation

@HiveType(typeId: 3)
class Fixture {
  @HiveField(0)
  final int fixtureId;

  @HiveField(1)
  final String date;

  @HiveField(2)
  final String homeTeam;

  @HiveField(3)
  final String awayTeam;

  @HiveField(4)
  final String homeTeamLogo;

  @HiveField(5)
  final String awayTeamLogo;

  @HiveField(6)
  final int homeScore;

  @HiveField(7)
  final int awayScore;

  Fixture({
    required this.fixtureId,
    required this.date,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeTeamLogo,
    required this.awayTeamLogo,
    required this.homeScore,
    required this.awayScore,
  });

  // Factory method to create a Fixture object from JSON
  factory Fixture.fromJson(Map<String, dynamic> json) {
    final fixture = json['fixture'];
    final homeTeam = json['teams']['home'];
    final awayTeam = json['teams']['away'];
    final goals = json['goals'];

    return Fixture(
      fixtureId: fixture['id'],
      date: fixture['date'], // Adjust the date format if necessary
      homeTeam: homeTeam['name'],
      awayTeam: awayTeam['name'],
      homeTeamLogo: homeTeam['logo'],
      awayTeamLogo: awayTeam['logo'],
      homeScore: goals['home'] ?? 0, // Default to 0 if null
      awayScore: goals['away'] ?? 0, // Default to 0 if null
    );
  }
}
