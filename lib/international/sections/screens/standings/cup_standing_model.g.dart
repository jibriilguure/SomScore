// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cup_standing_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CupStandingAdapter extends TypeAdapter<CupStanding> {
  @override
  final int typeId = 5;

  @override
  CupStanding read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CupStanding(
      rank: fields[0] as int,
      teamName: fields[1] as String,
      teamLogo: fields[2] as String,
      played: fields[3] as int,
      win: fields[4] as int,
      draw: fields[5] as int,
      loss: fields[6] as int,
      goalDifference: fields[7] as int,
      points: fields[8] as int,
      group: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CupStanding obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.rank)
      ..writeByte(1)
      ..write(obj.teamName)
      ..writeByte(2)
      ..write(obj.teamLogo)
      ..writeByte(3)
      ..write(obj.played)
      ..writeByte(4)
      ..write(obj.win)
      ..writeByte(5)
      ..write(obj.draw)
      ..writeByte(6)
      ..write(obj.loss)
      ..writeByte(7)
      ..write(obj.goalDifference)
      ..writeByte(8)
      ..write(obj.points)
      ..writeByte(9)
      ..write(obj.group);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CupStandingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
