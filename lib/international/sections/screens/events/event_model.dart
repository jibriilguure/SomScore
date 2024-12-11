import 'package:hive/hive.dart';

part 'event_model.g.dart';

@HiveType(typeId: 40)
class Event {
  @HiveField(0)
  final Time time;

  @HiveField(1)
  final EventTeam team;

  @HiveField(2)
  final EventPlayer player;

  @HiveField(3)
  final Assist? assist;

  @HiveField(4)
  final String type;

  @HiveField(5)
  final String detail;

  @HiveField(6)
  final String? comments;

  Event({
    required this.time,
    required this.team,
    required this.player,
    this.assist,
    required this.type,
    required this.detail,
    this.comments,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    try {
      return Event(
        time: Time.fromJson(json['time'] ?? {}),
        team: EventTeam.fromJson(json['team'] ?? {}),
        player: EventPlayer.fromJson(json['player'] ?? {}),
        assist: json['assist'] != null ? Assist.fromJson(json['assist']) : null,
        type: json['type'] ?? 'Unknown',
        detail: json['detail'] ?? 'No detail',
        comments: json['comments'],
      );
    } catch (e, stacktrace) {
      print('Error parsing Event: $e');
      print('Stacktrace: $stacktrace');
      print('JSON Data: $json');
      rethrow;
    }
  }
}

@HiveType(typeId: 41)
class Time {
  @HiveField(0)
  final int elapsed;

  @HiveField(1)
  final int? extra;

  Time({
    required this.elapsed,
    this.extra,
  });

  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(
      elapsed: json['elapsed'] ?? 0,
      extra: json['extra'],
    );
  }
}

@HiveType(typeId: 42)
class EventTeam {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? logo;

  EventTeam({
    required this.id,
    required this.name,
    this.logo,
  });

  factory EventTeam.fromJson(Map<String, dynamic> json) {
    return EventTeam(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      logo: json['logo'],
    );
  }
}

@HiveType(typeId: 43)
class EventPlayer {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  EventPlayer({
    required this.id,
    required this.name,
  });

  factory EventPlayer.fromJson(Map<String, dynamic> json) {
    return EventPlayer(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
    );
  }
}

@HiveType(typeId: 44)
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
