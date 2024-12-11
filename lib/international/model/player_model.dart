import 'package:hive/hive.dart';

part 'player_model.g.dart';

@HiveType(typeId: 20) // Ensure a unique typeId
class Player {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String firstname;

  @HiveField(3)
  final String lastname;

  @HiveField(4)
  final int? age;

  @HiveField(5)
  final Birth? birth;

  @HiveField(6)
  final String? nationality;

  @HiveField(7)
  final String? height;

  @HiveField(8)
  final String? weight;

  @HiveField(9)
  final int? number;

  @HiveField(10)
  final String? position;

  @HiveField(11)
  final String? photo;

  Player({
    required this.id,
    required this.name,
    required this.firstname,
    required this.lastname,
    this.age,
    this.birth,
    this.nationality,
    this.height,
    this.weight,
    this.number,
    this.position,
    this.photo,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      age: json['age'],
      birth: json['birth'] != null ? Birth.fromJson(json['birth']) : null,
      nationality: json['nationality'],
      height: json['height'],
      weight: json['weight'],
      number: json['number'],
      position: json['position'],
      photo: json['photo'],
    );
  }
}

@HiveType(typeId: 21)
class Birth {
  @HiveField(0)
  final String? date;

  @HiveField(1)
  final String? place;

  @HiveField(2)
  final String? country;

  Birth({
    this.date,
    this.place,
    this.country,
  });

  factory Birth.fromJson(Map<String, dynamic> json) {
    return Birth(
      date: json['date'],
      place: json['place'],
      country: json['country'],
    );
  }
}
