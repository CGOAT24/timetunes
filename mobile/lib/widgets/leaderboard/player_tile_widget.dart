import 'package:flutter/material.dart';

import '../../models/player.dart';
import '../../providers/timetune_amqp_providers.dart';

class PlayerTileWidget extends StatelessWidget {
  final int rank;
  final String userId;
  final int points;

  const PlayerTileWidget({
    super.key,
    required this.rank,
    required this.userId,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    Player? player = TimeTunesAMQPProviders.getCurrentGameState()?.players.where((player)=>player.id == userId).firstOrNull;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white30,
            child: Text('$rank', style: const TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              player?.username??"",
              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
          Text('$points points', style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}