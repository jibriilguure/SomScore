import 'package:hive/hive.dart';

part 'venue_model.g.dart';

@HiveType(typeId: 31) // Ensure unique typeId
class Venue {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String address;

  @HiveField(3)
  final String city;

  @HiveField(4)
  final int capacity;

  @HiveField(5)
  final String surface;

  @HiveField(6)
  final String image;

  Venue({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.capacity,
    required this.surface,
    required this.image,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      capacity: json['capacity'],
      surface: json['surface'],
      image: json['image'],
    );
  }
}
