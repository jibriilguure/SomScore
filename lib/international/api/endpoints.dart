class ApiFootballEndpoints {
  static const String baseUrl = 'https://api-football-v1.p.rapidapi.com/v3/';

  // Headers for API key and host
  static Map<String, String> headers(String apiKey) => {
        'X-RapidAPI-Key': apiKey,
        'X-RapidAPI-Host': 'api-football-v1.p.rapidapi.com',
      };

  // Leagues
  static const String getLeagues = '${baseUrl}leagues';

  // Teams
  static String getTeams(int leagueId, int season) =>
      '${baseUrl}teams?league=$leagueId&season=$season';

  // Fixtures
  static String getFixturesByDate(String date) =>
      '${baseUrl}fixtures?date=$date';
  static String getFixturesByLeagueAndSeason(int leagueId, int season) =>
      '${baseUrl}fixtures?league=$leagueId&season=$season';

  // Standings
  static String getStandings(int leagueId, int season) =>
      '${baseUrl}standings?league=$leagueId&season=$season';

  // Players
  static String getPlayers(int teamId, int season) =>
      '${baseUrl}players?team=$teamId&season=$season';

  // Top Scorers
  static String getTopScorers(int leagueId, int season) =>
      '${baseUrl}players/topscorers?league=$leagueId&season=$season';

  // Live Scores
  static const String getLiveScores = '${baseUrl}fixtures/live';

  // Statistics
  static String getStatisticsForMatch(int fixtureId) =>
      '${baseUrl}fixtures/statistics?fixture=$fixtureId';

  // Odds
  static String getOdds(int leagueId, int season) =>
      '${baseUrl}odds?league=$leagueId&season=$season';
}
