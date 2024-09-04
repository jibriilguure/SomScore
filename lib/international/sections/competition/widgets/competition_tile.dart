import 'package:flutter/material.dart';

import '../model/competition_model.dart';

class CompetitionTile extends StatelessWidget {
  final Competition competition;

  CompetitionTile({required this.competition});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(competition.logoUrl),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    competition.countryName,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    competition.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
          Divider(color: Colors.grey[800]),
        ],
      ),
    );
  }
}
