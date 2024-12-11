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
      rank: json['rank'],
      teamName: json['team']['name'],
      teamLogo: json['team']['logo'],
      played: json['all']['played'],
      win: json['all']['win'],
      draw: json['all']['draw'],
      loss: json['all']['lose'],
      goalDifference: json['goalsDiff'],
      points: json['points'],
      group: json['group'],
    );
  }
}
