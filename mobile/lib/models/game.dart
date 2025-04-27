import 'player.dart';

class Game {
  final String id;
  final String playlistId;
  final String pin;
  final int currentRound;
  final String brokerQueue;
  final List<Player>? players;

  Game({
    required this.id,
    required this.playlistId,
    required this.pin,
    required this.currentRound,
    required this.brokerQueue,
    required this.players,
  });

  // Convertir un JSON en objet Dart
  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      playlistId: json['playlistId'],
      pin: json['pin'],
      brokerQueue: json['brokerQueue'],
      currentRound: json['currentRound'],
      players: (json['players'] != null)
          ? (json['players'] as List).map((p) => Player.fromJson(p)).toList()
          : [],
    );
  }

  // Convertir un objet Dart en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playlistId': playlistId,
      'pin': pin,
      'currentRound': currentRound,
      'brokerQueue': brokerQueue,
      'players': players?.map((p) => p.toJson()).toList(),
    };
  }
}
