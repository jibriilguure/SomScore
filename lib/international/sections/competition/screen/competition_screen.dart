// competition_screen.dart
import 'package:flutter/material.dart';
import '../model/competition_model.dart';
import '../services/competition_service.dart';
import '../widgets/competition_tile.dart';

class CompetitionScreen extends StatelessWidget {
  final CompetitionService competitionService = CompetitionService();

  CompetitionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Competitions'),
      ),
      body: FutureBuilder<List<Competition>>(
        future: competitionService.fetchCompetitions(
            nDays: 1), // Fetch data valid for 1 day
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No competitions found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final competition = snapshot.data![index];
                return CompetitionTile(competition: competition);
              },
            );
          }
        },
      ),
    );
  }
}
