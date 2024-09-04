// competition_tile.dart
import 'package:flutter/material.dart';
import 'package:somscore/international/sections/competition/screen/competition_details.dart';
import '../model/competition_model.dart';

class CompetitionTile extends StatelessWidget {
  final Competition competition;

  CompetitionTile({required this.competition});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        competition.logoUrl,
        width: 50,
        height: 50,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.sports),
      ),
      title: Text(competition.name),
      subtitle: Text(competition.countryName),
      trailing: Icon(Icons.arrow_forward),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) =>
                    CompetitionDetailScreen(competition: competition)));
      },
    );
  }
}
