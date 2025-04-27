import 'dart:async';

import 'package:flutter/material.dart';
import '../../models/game_state.dart';
import '../../models/score.dart';
import '../../providers/timetune_amqp_providers.dart';
import '../../providers/timetunes_rest_providers.dart';
import '../../services/spotify_services.dart';
import '../../widgets/leaderboard/player_tile_widget.dart';
import '../../widgets/leaderboard/podium_entry_widget.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late final ScoreBoard _scoreBoard;
  late final List<Score> _podium;
  late final List<Score> _rest;
  late bool _isFinish;

  void _leave(BuildContext context) async {
    bool? shouldLeave = true;
    if (!_isFinish) {
      shouldLeave = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Quitter la partie ?"),
          content:
              const Text("Es-tu sûr de vouloir quitter la partie en cours ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text(
                "Quitter",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      );
    }

    if (shouldLeave == true) {
      TimeTunesAMQPProviders.leave();
      await TimeTunesRESTProvider.leaveGame(
          TimeTunesAMQPProviders.getCurrentGameState()?.id ?? "");
      SpotifyServices.stop();
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }

  void _nextRound(GameState gameState) {
    if (mounted) {
      TimeTunesAMQPProviders.setCallback(null);
      Navigator.pushReplacementNamed(context, '/guess');
    }
  }

  @override
  void initState() {
    super.initState();
    _scoreBoard = TimeTunesAMQPProviders.getCurrentGameState()!.scoreBoard;
    _podium = _scoreBoard.scores.take(3).toList();
    _rest = _scoreBoard.scores.length > 3 ? _scoreBoard.scores.sublist(3) : [];
    _isFinish =
        (TimeTunesAMQPProviders.getCurrentGameState()?.currentRound ?? 0) >= 6;

    if (!_isFinish) {
      if (TimeTunesRESTProvider.createdGameId ==
          TimeTunesAMQPProviders.getCurrentGameState()?.id) {
        Future.delayed(const Duration(seconds: 10), () {
          final gameId = TimeTunesAMQPProviders.getCurrentGameState()?.id;
          if (gameId != null) {
            TimeTunesRESTProvider.startRound(gameId);
          }
        });
      }
      TimeTunesAMQPProviders.setCallback(_nextRound);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'TIMETUNES',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () => _leave(context), icon: const Icon(Icons.logout)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _isFinish
              ? const Text("La partie est terminée")
              : Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '#${_scoreBoard.getCurrentRank()}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _scoreBoard.getCurrentRankMessage(),
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (_podium.length > 1)
                  PodiumEntryWidget(
                    userId: _podium[1].userId,
                    points: _podium[1].score,
                    rank: 2,
                    barHeight: 100,
                    avatarColor: Colors.pink,
                    crown: false,
                  ),
                const SizedBox(width: 16),
                PodiumEntryWidget(
                  userId: _podium[0].userId,
                  points: _podium[0].score,
                  rank: 1,
                  barHeight: 120,
                  avatarColor: Colors.green,
                  crown: true,
                ),
                const SizedBox(width: 16),
                if (_podium.length > 2)
                  PodiumEntryWidget(
                    userId: _podium[2].userId,
                    points: _podium[2].score,
                    rank: 3,
                    barHeight: 80,
                    avatarColor: Colors.purple,
                    crown: false,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: _rest.length,
                itemBuilder: (context, index) {
                  final score = _rest[index];
                  return PlayerTileWidget(
                    rank: index + 4,
                    userId: score.userId,
                    points: score.score,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
