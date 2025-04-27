import 'package:flutter/material.dart';

import '../../models/player.dart';
import '../../providers/timetune_amqp_providers.dart';

class PodiumEntryWidget extends StatefulWidget {
  final String userId;
  final int points;
  final int rank;
  final double barHeight;
  final Color avatarColor;
  final bool crown;

  const PodiumEntryWidget({
    super.key,
    required this.userId,
    required this.points,
    required this.rank,
    required this.barHeight,
    required this.avatarColor,
    required this.crown,
  });

  @override
  State<PodiumEntryWidget> createState() => _PodiumEntryState();
}

class _PodiumEntryState extends State<PodiumEntryWidget>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late Animation<double> _heightAnimation;
  late Animation<int> _scoreAnimation;

  late AnimationController _crownController;
  late Animation<double> _crownAnimation;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _heightAnimation = Tween<double>(begin: 0, end: widget.barHeight).animate(
        CurvedAnimation(parent: _mainController, curve: Curves.easeOut));

    _scoreAnimation = IntTween(begin: 0, end: widget.points).animate(
        CurvedAnimation(parent: _mainController, curve: Curves.easeOut));

    _crownController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _crownAnimation = Tween<double>(begin: -0.1, end: 0.1).animate(
        CurvedAnimation(parent: _crownController, curve: Curves.easeInOut));

    _mainController.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.crown) {
        _crownController.repeat(reverse: true);
      }
    });

    _mainController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _crownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Player? player = TimeTunesAMQPProviders.getCurrentGameState()
        ?.players
        .where((player) => player.id == widget.userId)
        .firstOrNull;
    return AnimatedBuilder(
      animation: Listenable.merge([_mainController, _crownController]),
      builder: (context, child) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipOval(
                child: Image.network(
                  player?.profileImageUrl ?? "",
                  width: MediaQuery.of(context).size.height * 0.08,
                  height: MediaQuery.of(context).size.height * 0.08,
                  fit: BoxFit.cover,
                ),
              ),
              if (widget.crown)
                Positioned(
                  top: 0,
                  child: Transform.rotate(
                    angle: _crownAnimation.value,
                    child: const Icon(
                      Icons.emoji_events,
                      color: Colors.yellow,
                      size: 30,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            player?.username ?? "",
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          Text(
            '${_scoreAnimation.value} pts',
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
          const SizedBox(height: 6),
          Container(
            width: 40,
            height: _heightAnimation.value,
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              '${widget.rank}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
