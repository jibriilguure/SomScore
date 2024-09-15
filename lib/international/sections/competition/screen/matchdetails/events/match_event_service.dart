import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:somscore/international/api/endpoints.dart';
import 'package:somscore/key.dart';

import 'event_model.dart'; // Ensure this is the correct key file

class MatchEventService {
  final String apiUrl = ApiFootballEndpoints.getMatchEvent;
  final String apiKey = Config.apiFootballApiKey;

  Future<List<Event>> fetchMatchEvents(int fixtureId) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl?fixture=$fixtureId'),
        headers: {
          'X-RapidAPI-Key': apiKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('API Response: $data');

        if (data['response'] == null || data['response'].isEmpty) {
          throw Exception('No events found for this fixture');
        }

        List<Event> events = (data['response'] as List)
            .map((event) => Event.fromJson(event))
            .toList();

        return events;
      } else {
        throw Exception('Failed to fetch match events');
      }
    } catch (error) {
      print('Error fetching match events: $error');
      return [];
    }
  }
}
