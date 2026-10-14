import 'package:synamyk/domain/models/common/json_read.dart';

/// Elo game rating — `GET /api/game/rating/me` and leaderboard rows.
class GameRating {
  const GameRating({
    required this.userId,
    required this.fullName,
    required this.avatarUrl,
    required this.rating,
    required this.peakRating,
    required this.rank,
    required this.gamesPlayed,
    required this.wins,
    required this.losses,
    required this.draws,
    required this.winStreak,
    required this.league,
    required this.leagueName,
    required this.nextLeagueRating,
  });

  final int? userId;
  final String fullName;
  final String? avatarUrl;
  final int rating;
  final int peakRating;
  final int? rank;
  final int gamesPlayed;
  final int wins;
  final int losses;
  final int draws;
  final int winStreak;

  /// `BRONZE | SILVER | GOLD | PLATINUM | DIAMOND`.
  final String league;
  final String leagueName;

  /// `null` for DIAMOND.
  final int? nextLeagueRating;

  /// Rating where the current league starts (BRONZE has no floor above the
  /// 100-point minimum), used for the progress bar to [nextLeagueRating].
  int get leagueFloor => switch (league) {
    'SILVER' => 1100,
    'GOLD' => 1300,
    'PLATINUM' => 1500,
    'DIAMOND' => 1700,
    _ => 100,
  };

  factory GameRating.fromJson(Map<String, dynamic> json) {
    return GameRating(
      userId: readInt(json['userId']),
      fullName: readStringOr(json['fullName']),
      avatarUrl: readString(json['avatarUrl']),
      rating: readIntOr(json['rating'], 1000),
      peakRating: readIntOr(json['peakRating'], 1000),
      rank: readInt(json['rank']),
      gamesPlayed: readIntOr(json['gamesPlayed']),
      wins: readIntOr(json['wins']),
      losses: readIntOr(json['losses']),
      draws: readIntOr(json['draws']),
      winStreak: readIntOr(json['winStreak']),
      league: readStringOr(json['league'], 'BRONZE'),
      leagueName: readStringOr(json['leagueName']),
      nextLeagueRating: readInt(json['nextLeagueRating']),
    );
  }
}
