// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompetitionAdapter extends TypeAdapter<Competition> {
  @override
  final int typeId = 0;

  @override
  Competition read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Competition(
      id: fields[0] as int,
      name: fields[1] as String,
      type: fields[2] as String,
      logoUrl: fields[3] as String,
      countryName: fields[4] as String,
      countryCode: fields[5] as String?,
      fetchDate: fields[6] as DateTime,
      events: fields[7] as bool,
      lineups: fields[8] as bool,
      statisticsFixtures: fields[9] as bool,
      statisticsPlayers: fields[10] as bool,
      standings: fields[11] as bool,
      players: fields[12] as bool,
      topScorers: fields[13] as bool,
      topAssists: fields[14] as bool,
      topCards: fields[15] as bool,
      injuries: fields[16] as bool,
      predictions: fields[17] as bool,
      odds: fields[18] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Competition obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.logoUrl)
      ..writeByte(4)
      ..write(obj.countryName)
      ..writeByte(5)
      ..write(obj.countryCode)
      ..writeByte(6)
      ..write(obj.fetchDate)
      ..writeByte(7)
      ..write(obj.events)
      ..writeByte(8)
      ..write(obj.lineups)
      ..writeByte(9)
      ..write(obj.statisticsFixtures)
      ..writeByte(10)
      ..write(obj.statisticsPlayers)
      ..writeByte(11)
      ..write(obj.standings)
      ..writeByte(12)
      ..write(obj.players)
      ..writeByte(13)
      ..write(obj.topScorers)
      ..writeByte(14)
      ..write(obj.topAssists)
      ..writeByte(15)
      ..write(obj.topCards)
      ..writeByte(16)
      ..write(obj.injuries)
      ..writeByte(17)
      ..write(obj.predictions)
      ..writeByte(18)
      ..write(obj.odds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompetitionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
