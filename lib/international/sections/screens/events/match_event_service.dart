import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:somscore/key.dart';
import 'event_model.dart';

class MatchEventService {
  final String apiUrl = "https://v3.football.api-sports.io/fixtures/events";
  final String apiKey = Config.apiFootballApiKey;

  Future<List<Event>> fetchMatchEvents(int fixtureId) async {
    final String cacheKey = 'match_events_$fixtureId';
    var eventBox = await Hive.openBox<List>('events');
    var metadataBox = await Hive.openBox('metadata');

    if (!_isCacheValid(metadataBox, fixtureId)) {
      try {
        final response = await http.get(
          Uri.parse('$apiUrl?fixture=$fixtureId'),
          headers: {
            'x-apisports-key': apiKey,
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data['response'] == null || data['response'].isEmpty) {
            throw Exception("No events found for this fixture");
          }

          // Log raw data for debugging
          print('Raw JSON Data: ${data['response']}');

          // Parse and log each event
          List<Event> events = (data['response'] as List).map((e) {
            try {
              print('Parsing Event: $e');
              return Event.fromJson(e);
            } catch (e) {
              print('Error parsing Event: $e');
              rethrow;
            }
          }).toList();

          await eventBox.put(cacheKey, events);
          await metadataBox.put(
              'lastFetchTime_$cacheKey', DateTime.now().toIso8601String());

          return events;
        } else {
          throw Exception("Failed to fetch match events");
        }
      } catch (error) {
        print("Error fetching match events: $error");
        return [];
      }
    } else {
      return (eventBox.get(cacheKey) as List).cast<Event>();
    }
  }

  bool _isCacheValid(Box metadataBox, int fixtureId) {
    final String cacheKey = 'match_events_$fixtureId';
    final lastFetchTime = metadataBox.get('lastFetchTime_$cacheKey');
    if (lastFetchTime == null) {
      return false;
    }
    final lastFetchDateTime = DateTime.parse(lastFetchTime);
    return DateTime.now().difference(lastFetchDateTime).inMinutes < 10;
  }
}
