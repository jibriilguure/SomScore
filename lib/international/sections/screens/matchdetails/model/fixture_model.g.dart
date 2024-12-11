// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fixture_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FixtureMatchDetailAdapter extends TypeAdapter<FixtureMatchDetail> {
  @override
  final int typeId = 7;

  @override
  FixtureMatchDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FixtureMatchDetail(
      id: fields[0] as int?,
      referee: fields[1] as String?,
      timezone: fields[2] as String,
      date: fields[3] as String,
      timestamp: fields[4] as int,
      periods: fields[5] as Periods,
      venue: fields[6] as Venue,
      status: fields[7] as Status,
      teamsMatch: fields[8] as TeamsMatch,
      goals: fields[9] as Goals,
      score: fields[10] as Score,
    );
  }

  @override
  void write(BinaryWriter writer, FixtureMatchDetail obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.referee)
      ..writeByte(2)
      ..write(obj.timezone)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.periods)
      ..writeByte(6)
      ..write(obj.venue)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.teamsMatch)
      ..writeByte(9)
      ..write(obj.goals)
      ..writeByte(10)
      ..write(obj.score);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FixtureMatchDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PeriodsAdapter extends TypeAdapter<Periods> {
  @override
  final int typeId = 8;

  @override
  Periods read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Periods(
      first: fields[0] as int?,
      second: fields[1] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Periods obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.first)
      ..writeByte(1)
      ..write(obj.second);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PeriodsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VenueAdapter extends TypeAdapter<Venue> {
  @override
  final int typeId = 9;

  @override
  Venue read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Venue(
      id: fields[0] as int?,
      name: fields[1] as String?,
      city: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Venue obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.city);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VenueAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StatusAdapter extends TypeAdapter<Status> {
  @override
  final int typeId = 10;

  @override
  Status read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Status(
      long: fields[0] as String,
      short: fields[1] as String,
      elapsed: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Status obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.long)
      ..writeByte(1)
      ..write(obj.short)
      ..writeByte(2)
      ..write(obj.elapsed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TeamsMatchAdapter extends TypeAdapter<TeamsMatch> {
  @override
  final int typeId = 11;

  @override
  TeamsMatch read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TeamsMatch(
      home: fields[0] as Teams,
      away: fields[1] as Teams,
    );
  }

  @override
  void write(BinaryWriter writer, TeamsMatch obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.home)
      ..writeByte(1)
      ..write(obj.away);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeamsMatchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TeamsAdapter extends TypeAdapter<Teams> {
  @override
  final int typeId = 12;

  @override
  Teams read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Teams(
      id: fields[0] as int,
      name: fields[1] as String,
      logo: fields[2] as String,
      winner: fields[3] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Teams obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.logo)
      ..writeByte(3)
      ..write(obj.winner);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeamsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GoalsAdapter extends TypeAdapter<Goals> {
  @override
  final int typeId = 13;

  @override
  Goals read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Goals(
      home: fields[0] as int?,
      away: fields[1] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Goals obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.home)
      ..writeByte(1)
      ..write(obj.away);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ScoreAdapter extends TypeAdapter<Score> {
  @override
  final int typeId = 14;

  @override
  Score read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Score(
      halftime: fields[0] as HalfScore?,
      fulltime: fields[1] as HalfScore?,
      extratime: fields[2] as HalfScore?,
      penalty: fields[3] as HalfScore?,
    );
  }

  @override
  void write(BinaryWriter writer, Score obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.halftime)
      ..writeByte(1)
      ..write(obj.fulltime)
      ..writeByte(2)
      ..write(obj.extratime)
      ..writeByte(3)
      ..write(obj.penalty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HalfScoreAdapter extends TypeAdapter<HalfScore> {
  @override
  final int typeId = 15;

  @override
  HalfScore read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HalfScore(
      home: fields[0] as int?,
      away: fields[1] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, HalfScore obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.home)
      ..writeByte(1)
      ..write(obj.away);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HalfScoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
