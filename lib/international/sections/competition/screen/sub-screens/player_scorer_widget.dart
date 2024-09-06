import 'package:flutter/material.dart';

class PlayerCard extends StatelessWidget {
  final String rank;
  final String playerName;
  final String teamName;
  final String goals;
  final String imageUrl;

  const PlayerCard({
    Key? key,
    required this.rank,
    required this.playerName,
    required this.teamName,
    required this.goals,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(6),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(rank, style: const TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 10),
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        playerName,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        teamName, // Display the team name here
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(goals,
                style: const TextStyle(color: Colors.redAccent, fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
