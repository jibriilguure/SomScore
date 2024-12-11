import 'package:hive/hive.dart';

part 'team_model.g.dart';

@HiveType(typeId: 30) // Ensure unique typeId
class Team {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? code;

  @HiveField(3)
  final String? country;

  @HiveField(4)
  final int? founded;

  @HiveField(5)
  final bool national;

  @HiveField(6)
  final String? logo;

  Team({
    required this.id,
    required this.name,
    this.code,
    this.country,
    this.founded,
    required this.national,
    this.logo,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    try {
      return Team(
        id: json['id'] ?? 0, // Default to 0 if `id` is null
        name:
            json['name'] ?? 'Unknown', // Default to 'Unknown' if `name` is null
        code: json['code'], // Nullable field
        country: json['country'], // Nullable field
        founded: json['founded'], // Nullable field
        national:
            json['national'] ?? false, // Default to false if `national` is null
        logo: json['logo'], // Nullable field
      );
    } catch (e, stacktrace) {
      print('Error parsing Team: $e');
      print('Stacktrace: $stacktrace');
      print('JSON Data: $json');
      rethrow; // Re-throw the error after logging
    }
  }
}
