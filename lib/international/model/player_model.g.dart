// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerAdapter extends TypeAdapter<Player> {
  @override
  final int typeId = 20;

  @override
  Player read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Player(
      id: fields[0] as int,
      name: fields[1] as String,
      firstname: fields[2] as String,
      lastname: fields[3] as String,
      age: fields[4] as int?,
      birth: fields[5] as Birth?,
      nationality: fields[6] as String?,
      height: fields[7] as String?,
      weight: fields[8] as String?,
      number: fields[9] as int?,
      position: fields[10] as String?,
      photo: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Player obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.firstname)
      ..writeByte(3)
      ..write(obj.lastname)
      ..writeByte(4)
      ..write(obj.age)
      ..writeByte(5)
      ..write(obj.birth)
      ..writeByte(6)
      ..write(obj.nationality)
      ..writeByte(7)
      ..write(obj.height)
      ..writeByte(8)
      ..write(obj.weight)
      ..writeByte(9)
      ..write(obj.number)
      ..writeByte(10)
      ..write(obj.position)
      ..writeByte(11)
      ..write(obj.photo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BirthAdapter extends TypeAdapter<Birth> {
  @override
  final int typeId = 21;

  @override
  Birth read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Birth(
      date: fields[0] as String?,
      place: fields[1] as String?,
      country: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Birth obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.place)
      ..writeByte(2)
      ..write(obj.country);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BirthAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
