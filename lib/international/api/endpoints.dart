import '../../key.dart';

class ApiFootballEndpoints {
  static const String baseUrl = 'https://v3.football.api-sports.io/';

  // Headers for API key and host
  static Map<String, String> headers() => {
        'X-RapidAPI-Key': Config.apiFootballApiKey,
        'X-RapidAPI-Host': 'api-football-v1.p.rapidapi.com',
      };

  // Leagues
  static const String getLeagues = '${baseUrl}leagues';

  static const String getTopScorers = '${baseUrl}players/topscorers';
}
