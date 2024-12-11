import 'package:hive/hive.dart';

part 'top_scorer_model.g.dart'; // Part file for Hive adapter

@HiveType(typeId: 1)
class Player {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String firstName;

  @HiveField(3)
  final String lastName;

  @HiveField(4)
  final String nationality;

  @HiveField(5)
  final String? photo; // Make photo nullable

  @HiveField(6)
  final Team team;

  @HiveField(7)
  final int totalGoals;

  Player({
    required this.id,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.nationality,
    this.photo, // Nullable
    required this.team,
    required this.totalGoals,
  });

  // Factory method to create a Player object from JSON
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['player']['id'] as int,
      name: json['player']['name'] ?? '',
      firstName: json['player']['firstname'] ?? '',
      lastName: json['player']['lastname'] ?? '',
      nationality: json['player']['nationality'] ?? '',
      photo: json['player']
          ['photo'], // This can be null, so no ?? fallback here
      team: Team.fromJson(json['statistics'][0]['team']),
      totalGoals:
          json['statistics'][0]['goals']['total'] ?? 0, // Default to 0 if null
    );
  }
}

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
