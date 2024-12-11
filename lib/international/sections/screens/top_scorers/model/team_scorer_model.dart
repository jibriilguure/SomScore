import 'package:hive/hive.dart';

part 'team_scorer_model.g.dart'; // Part file for Hive adapter

@HiveType(typeId: 2)
class Team {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String logo;

  Team({
    required this.id,
    required this.name,
    required this.logo,
  });

  // Factory method to create a Team object from JSON
  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] as int,
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
    );
  }
}
