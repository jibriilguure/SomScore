// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventAdapter extends TypeAdapter<Event> {
  @override
  final int typeId = 40;

  @override
  Event read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Event(
      time: fields[0] as Time,
      team: fields[1] as EventTeam,
      player: fields[2] as EventPlayer,
      assist: fields[3] as Assist?,
      type: fields[4] as String,
      detail: fields[5] as String,
      comments: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Event obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.team)
      ..writeByte(2)
      ..write(obj.player)
      ..writeByte(3)
      ..write(obj.assist)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.detail)
      ..writeByte(6)
      ..write(obj.comments);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TimeAdapter extends TypeAdapter<Time> {
  @override
  final int typeId = 41;

  @override
  Time read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Time(
      elapsed: fields[0] as int,
      extra: fields[1] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Time obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.elapsed)
      ..writeByte(1)
      ..write(obj.extra);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EventTeamAdapter extends TypeAdapter<EventTeam> {
  @override
  final int typeId = 42;

  @override
  EventTeam read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventTeam(
      id: fields[0] as int,
      name: fields[1] as String,
      logo: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, EventTeam obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.logo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventTeamAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EventPlayerAdapter extends TypeAdapter<EventPlayer> {
  @override
  final int typeId = 43;

  @override
  EventPlayer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventPlayer(
      id: fields[0] as int,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EventPlayer obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventPlayerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AssistAdapter extends TypeAdapter<Assist> {
  @override
  final int typeId = 44;

  @override
  Assist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Assist(
      id: fields[0] as int?,
      name: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Assist obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
