import 'music.dart';
import 'player.dart';
import 'round.dart';
import 'score.dart';

class GameState {
  final String id;
  final String playlistId;
  final String pin;
  final int currentRound;
  final List<Round> rounds;
  final List<Player> players;
  final List<Music> deck;
  final ScoreBoard scoreBoard;

  GameState({
    required this.id,
    required this.playlistId,
    required this.pin,
    required this.currentRound,
    required this.rounds,
    required this.players,
    required this.deck,
    required this.scoreBoard,
  });

  factory GameState.fromJson(Map<String, dynamic> json) {
    final scoresList = List<Map<String, dynamic>>.from(json['scores']);

    return GameState(
      id: json['id'],
      playlistId: json['playlistId'],
      pin: json['pin'],
      currentRound: json['currentRound'],
      rounds: (json['rounds'] as List<dynamic>? ?? [])
          .map((r) => Round.fromJson(r))
          .toList(),
      players:
          (json['players'] as List).map((p) => Player.fromJson(p)).toList(),
      deck: (json['deck'] as List).map((m) => Music.fromJson(m)).toList(),
      scoreBoard: ScoreBoard(scoresList),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playlistId': playlistId,
      'pin': pin,
      'currentRound': currentRound,
      'rounds': rounds
          .map((r) => {
                'id': r.id,
                'trackId': r.trackId,
                'startTime': r.startTime?.toIso8601String(),
                'index': r.index,
              })
          .toList(),
      'players': players.map((p) => p.toJson()).toList(),
      'deck': deck.map((m) => m.toJson()).toList(),
      'scoreBoard': scoreBoard,
    };
  }

  Round get round {
    return rounds[currentRound];
  }
}
