import 'package:hive/hive.dart';

part 'fixture_model.g.dart'; // Necessary for Hive

@HiveType(typeId: 7)
class FixtureMatchDetail {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String? referee;

  @HiveField(2)
  final String timezone;

  @HiveField(3)
  final String date;

  @HiveField(4)
  final int timestamp;

  @HiveField(5)
  final Periods periods;

  @HiveField(6)
  final Venue venue;

  @HiveField(7)
  final Status status;

  @HiveField(8)
  final TeamsMatch teamsMatch; // Added teams

  @HiveField(9)
  final Goals goals; // Added goals

  @HiveField(10)
  final Score score; // Added score

  FixtureMatchDetail({
    required this.id,
    this.referee,
    required this.timezone,
    required this.date,
    required this.timestamp,
    required this.periods,
    required this.venue,
    required this.status,
    required this.teamsMatch, // Required teams
    required this.goals, // Required goals
    required this.score, // Required score
  });
  factory FixtureMatchDetail.fromJson(Map<String, dynamic> json) {
    return FixtureMatchDetail(
      id: json['id'],
      referee: json['referee'] ?? 'Unknown', // Handle null values
      timezone: json['timezone'] ?? 'UTC',
      date: json['date'] ?? '',
      timestamp: json['timestamp'] ?? 0,
      periods: json['periods'] != null
          ? Periods.fromJson(json['periods'])
          : Periods(first: null, second: null),
      venue: json['venue'] != null
          ? Venue.fromJson(json['venue'])
          : Venue(id: null, name: null, city: null),
      status: json['status'] != null
          ? Status.fromJson(json['status'])
          : Status(long: 'Unknown', short: 'N/A', elapsed: null),
      teamsMatch: TeamsMatch.fromJson(json['teams']),
      goals: Goals.fromJson(json['goals']),
      score: Score.fromJson(json['score']),
    );
  }
}

@HiveType(typeId: 8)
class Periods {
  @HiveField(0)
  final int? first;

  @HiveField(1)
  final int? second;

  Periods({
    this.first,
    this.second,
  });

  factory Periods.fromJson(Map<String, dynamic> json) {
    return Periods(
      first: json['first'],
      second: json['second'],
    );
  }
}

@HiveType(typeId: 9)
class Venue {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String? city;

  Venue({
    this.id,
    this.name,
    this.city,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'],
      name: json['name'],
      city: json['city'],
    );
  }
}

@HiveType(typeId: 10)
class Status {
  @HiveField(0)
  final String long;

  @HiveField(1)
  final String short;

  @HiveField(2)
  final int? elapsed;

  Status({
    required this.long,
    required this.short,
    this.elapsed,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      long: json['long'],
      short: json['short'],
      elapsed: json['elapsed'],
    );
  }
}

@HiveType(typeId: 11)
class TeamsMatch {
  @HiveField(0)
  final Teams home;

  @HiveField(1)
  final Teams away;

  TeamsMatch({
    required this.home,
    required this.away,
  });

  factory TeamsMatch.fromJson(Map<String, dynamic> json) {
    return TeamsMatch(
      home: Teams.fromJson(json['home']),
      away: Teams.fromJson(json['away']),
    );
  }
}

@HiveType(typeId: 12)
class Teams {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String logo;

  @HiveField(3)
  final bool? winner;

  Teams({
    required this.id,
    required this.name,
    required this.logo,
    this.winner,
  });

  factory Teams.fromJson(Map<String, dynamic> json) {
    return Teams(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
      winner: json['winner'],
    );
  }
}

@HiveType(typeId: 13)
class Goals {
  @HiveField(0)
  final int? home;

  @HiveField(1)
  final int? away;

  Goals({
    this.home,
    this.away,
  });

  factory Goals.fromJson(Map<String, dynamic> json) {
    return Goals(
      home: json['home'],
      away: json['away'],
    );
  }
}

@HiveType(typeId: 14)
class Score {
  @HiveField(0)
  final HalfScore? halftime;

  @HiveField(1)
  final HalfScore? fulltime;

  @HiveField(2)
  final HalfScore? extratime;

  @HiveField(3)
  final HalfScore? penalty;

  Score({
    this.halftime,
    this.fulltime,
    this.extratime,
    this.penalty,
  });

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      halftime: json['halftime'] != null
          ? HalfScore.fromJson(json['halftime'])
          : null,
      fulltime: json['fulltime'] != null
          ? HalfScore.fromJson(json['fulltime'])
          : null,
      extratime: json['extratime'] != null
          ? HalfScore.fromJson(json['extratime'])
          : null,
      penalty:
          json['penalty'] != null ? HalfScore.fromJson(json['penalty']) : null,
    );
  }
}

@HiveType(typeId: 15)
class HalfScore {
  @HiveField(0)
  final int? home;

  @HiveField(1)
  final int? away;

  HalfScore({
    this.home,
    this.away,
  });

  factory HalfScore.fromJson(Map<String, dynamic> json) {
    return HalfScore(
      home: json['home'],
      away: json['away'],
    );
  }
}
