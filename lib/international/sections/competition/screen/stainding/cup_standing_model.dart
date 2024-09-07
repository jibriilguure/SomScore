import 'package:hive/hive.dart';

part 'cup_standing_model.g.dart'; // Hive adapter

@HiveType(typeId: 5)
class CupStanding {
  @HiveField(0)
  final int rank;

  @HiveField(1)
  final String teamName;

  @HiveField(2)
  final String teamLogo;

  @HiveField(3)
  final int played;

  @HiveField(4)
  final int win;

  @HiveField(5)
  final int draw;

  @HiveField(6)
  final int loss;

  @HiveField(7)
  final int goalDifference;

  @HiveField(8)
  final int points;

  @HiveField(9)
  final String group;

  CupStanding({
    required this.rank,
    required this.teamName,
    required this.teamLogo,
    required this.played,
    required this.win,
    required this.draw,
    required this.loss,
    required this.goalDifference,
    required this.points,
    required this.group,
  });

  factory CupStanding.fromJson(Map<String, dynamic> json) {
    return CupStanding(
      rank: json['rank'] ?? 0, // Ensure rank is not null
      teamName: json['team']['name'] ??
          'Unknown', // Provide default values for missing names
      teamLogo: json['team']['logo'] ?? '', // Handle missing logos
      played: json['all']['played'] ?? 0,
      win: json['all']['win'] ?? 0,
      draw: json['all']['draw'] ?? 0,
      loss: json['all']['lose'] ?? 0,
      goalDifference: json['goalsDiff'] ?? 0,
      points: json['points'] ?? 0, // Handle missing points
      group: json['group'] ?? 'Unknown', // Provide default for missing group
    );
  }
}
