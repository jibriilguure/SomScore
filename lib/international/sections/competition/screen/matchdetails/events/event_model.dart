import 'package:hive/hive.dart';

part 'event_model.g.dart';

@HiveType(typeId: 16)
class Event {
  @HiveField(0)
  final int elapsed;

  @HiveField(1)
  final int? extra;

  @HiveField(2)
  final Team team;

  @HiveField(3)
  final Player player;

  @HiveField(4)
  final Assist? assist;

  @HiveField(5)
  final String type;

  @HiveField(6)
  final String detail;

  @HiveField(7)
  final String? comments;

  Event({
    required this.elapsed,
    this.extra,
    required this.team,
    required this.player,
    this.assist,
    required this.type,
    required this.detail,
    this.comments,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      elapsed: json['time']['elapsed'],
      extra: json['time']['extra'],
      team: Team.fromJson(json['team']),
      player: Player.fromJson(json['player']),
      assist: json['assist'] != null ? Assist.fromJson(json['assist']) : null,
      type: json['type'],
      detail: json['detail'],
      comments: json['comments'],
    );
  }
}

@HiveType(typeId: 17)
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

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
    );
  }
}

@HiveType(typeId: 18)
class Player {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  Player({
    required this.id,
    required this.name,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
    );
  }
}

@HiveType(typeId: 19)
class Assist {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? name;

  Assist({
    this.id,
    this.name,
  });

  factory Assist.fromJson(Map<String, dynamic> json) {
    return Assist(
      id: json['id'],
      name: json['name'],
    );
  }
}
