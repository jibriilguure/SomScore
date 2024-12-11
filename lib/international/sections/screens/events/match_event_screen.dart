import 'package:flutter/material.dart';
import 'event_model.dart';
import 'match_event_service.dart';

class MatchEventScreen extends StatefulWidget {
  final int fixtureId;
  final int homeTeam;

  const MatchEventScreen({
    Key? key,
    required this.fixtureId,
    required this.homeTeam,
  }) : super(key: key);

  @override
  _MatchEventScreenState createState() => _MatchEventScreenState();
}

class _MatchEventScreenState extends State<MatchEventScreen> {
  late Future<List<Event>> futureEvents;
  final matchEventService = MatchEventService();

  @override
  void initState() {
    super.initState();
    futureEvents = matchEventService.fetchMatchEvents(widget.fixtureId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<List<Event>>(
        future: futureEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error in FutureBuilder: ${snapshot.error}');
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            print('No events found or snapshot is empty.');
            return const Center(
              child: Text(
                'No events found',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            List<Event> events = snapshot.data!;
            print('Fetched ${events.length} events.');

            // Sort events by 'elapsed' time (descending order)
            events.sort((a, b) => b.time.elapsed.compareTo(a.time.elapsed));

            return ListView.builder(
              itemCount: events.length,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemBuilder: (context, index) {
                final event = events[index];
                print(
                    'Event ${index + 1}: Player=${event.player.name}, Team=${event.team.name}, Type=${event.type}');
                return _buildEventRow(event);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildEventRow(Event event) {
    bool isHomeEvent = event.team.id == widget.homeTeam;
    final eventDetails = _getEventDetails(event);

    print(
        'Building row for event: Player=${event.player.name}, Type=${event.type}, IsHomeEvent=$isHomeEvent');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment:
            isHomeEvent ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isHomeEvent)
            Text('${event.time.elapsed}\'', style: _timeTextStyle),
          if (!isHomeEvent) const SizedBox(width: 10),
          Icon(eventDetails.icon, color: eventDetails.color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: isHomeEvent
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                if (event.type == 'Substitution')
                  _buildSubstitutionEvent(event)
                else
                  _buildGeneralEvent(event),
              ],
            ),
          ),
          if (!isHomeEvent)
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text('${event.time.elapsed}\'', style: _timeTextStyle),
            ),
        ],
      ),
    );
  }

  Widget _buildGeneralEvent(Event event) {
    print(
        'Building general event: Player=${event.player.name}, Detail=${event.detail}');
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        style: const TextStyle(color: Colors.white),
        children: [
          TextSpan(
            text: event.player.name ?? 'Unknown',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const TextSpan(text: '  '),
          TextSpan(text: event.detail ?? 'No detail'),
        ],
      ),
    );
  }

  Widget _buildSubstitutionEvent(Event event) {
    print(
        'Building substitution event: Player=${event.player.name}, Assist=${event.assist?.name}');
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.arrow_circle_left, color: Colors.green, size: 18),
            const SizedBox(width: 4),
            Text(
              'In: ${event.assist?.name ?? 'Unknown'}',
              style: const TextStyle(color: Colors.green),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.arrow_circle_right, color: Colors.red, size: 18),
            const SizedBox(width: 4),
            Text(
              'Out: ${event.player.name ?? 'Unknown'}',
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ],
    );
  }

  _EventDetails _getEventDetails(Event event) {
    switch (event.type) {
      case 'Goal':
        return _EventDetails(Icons.sports_soccer, Colors.white);
      case 'Card':
        if (event.detail == 'Yellow Card') {
          return _EventDetails(Icons.warning, Colors.yellow);
        } else {
          return _EventDetails(Icons.stop, Colors.red);
        }
      case 'Substitution':
        return _EventDetails(Icons.swap_horiz, Colors.green);
      default:
        return _EventDetails(Icons.info_outline, Colors.grey);
    }
  }

  TextStyle get _timeTextStyle =>
      TextStyle(color: Colors.grey[400], fontSize: 16);
}

class _EventDetails {
  final IconData icon;
  final Color color;

  _EventDetails(this.icon, this.color);
}
