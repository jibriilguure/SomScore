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
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No events found'));
          } else {
            List<Event> events = snapshot.data!;

            // Sort the events by 'elapsed'
            events.sort((a, b) => b.elapsed.compareTo(a.elapsed)); // DESC

            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];

                // Display the appropriate icon based on the event type
                IconData eventIcon;
                Color eventColor;

                switch (event.type) {
                  case 'Goal':
                    eventIcon = Icons.sports_soccer;
                    eventColor = Colors.white;
                    break;
                  case 'Card':
                    eventIcon = event.detail == 'Yellow Card'
                        ? Icons.warning
                        : Icons.stop; // Red cards can use a different icon
                    eventColor = event.detail == 'Yellow Card'
                        ? Colors.yellow
                        : Colors.red;
                    break;
                  case 'Substitution':
                    eventIcon = Icons.swap_horiz;
                    eventColor = Colors.green;
                    break;
                  default:
                    eventIcon = Icons.info_outline;
                    eventColor = Colors.grey;
                }

                // Check if it's a home or away team event
                bool isHomeEvent = event.team.id == widget.homeTeam;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: isHomeEvent
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isHomeEvent) ...[
                        // Home team events (left)
                        _buildEventRow(
                            event, eventIcon, eventColor, isHomeEvent),
                      ] else ...[
                        // Away team events (right)
                        _buildEventRow(
                            event, eventIcon, eventColor, isHomeEvent),
                      ],
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildEventRow(
      Event event, IconData eventIcon, Color eventColor, bool isHomeEvent) {
    return Row(
      mainAxisAlignment:
          isHomeEvent ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        if (isHomeEvent)
          // Home team time on the left
          Text(
            '${event.elapsed}\'',
            style: TextStyle(color: Colors.grey[400], fontSize: 16),
          ),
        if (!isHomeEvent) const SizedBox(width: 10),

        // Substitution arrows for substitution events
        if (event.type == 'subst')
          const Icon(
            Icons.compare_arrows, // This is the swap icon for substitutions
            color: Colors.green,
            size: 20,
          ),
        if (!isHomeEvent) const SizedBox(width: 10),

        // Event details (player name, event type)
        Column(
          crossAxisAlignment:
              isHomeEvent ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            if (event.type == 'subst') ...[
              // "In" player with arrow
              Row(
                children: [
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.green,
                    size: 18,
                  ),
                  Text(
                    ' In: ${event.assist?.name}',
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // "Out" player with arrow
              Row(
                children: [
                  const Icon(
                    Icons.arrow_back,
                    color: Colors.red,
                    size: 18,
                  ),
                  Text(
                    ' Out: ${event.player.name}',
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ] else ...[
              // General event text for other types (goals, cards)
              RichText(
                textAlign: isHomeEvent ? TextAlign.left : TextAlign.right,
                text: TextSpan(
                  style: const TextStyle(color: Colors.white),
                  children: [
                    TextSpan(
                      text: event.player.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: '  '),
                    TextSpan(text: event.detail),
                  ],
                ),
              ),
            ],
          ],
        ),

        if (!isHomeEvent)
          // Away team time on the right
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              '${event.elapsed}\'',
              style: TextStyle(color: Colors.grey[400], fontSize: 16),
            ),
          ),
      ],
    );
  }
}
