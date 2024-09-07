// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fixture_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FixtureAdapter extends TypeAdapter<Fixture> {
  @override
  final int typeId = 3;

  @override
  Fixture read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Fixture(
      fixtureId: fields[0] as int,
      date: fields[1] as String,
      homeTeam: fields[2] as String,
      awayTeam: fields[3] as String,
      homeTeamLogo: fields[4] as String,
      awayTeamLogo: fields[5] as String,
      homeScore: fields[6] as int,
      awayScore: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Fixture obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.fixtureId)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.homeTeam)
      ..writeByte(3)
      ..write(obj.awayTeam)
      ..writeByte(4)
      ..write(obj.homeTeamLogo)
      ..writeByte(5)
      ..write(obj.awayTeamLogo)
      ..writeByte(6)
      ..write(obj.homeScore)
      ..writeByte(7)
      ..write(obj.awayScore);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FixtureAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
