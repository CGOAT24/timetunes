import 'package:flutter/material.dart';

import '../../models/music.dart';
import '../../providers/timetune_amqp_providers.dart';

class AnswerRevealScreen extends StatefulWidget {
  const AnswerRevealScreen({super.key});

  @override
  State<AnswerRevealScreen> createState() => _AnswerRevealScreenState();
}

class _AnswerRevealScreenState extends State<AnswerRevealScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late bool _isCorrect;

  @override
  void initState() {
    super.initState();

    _isCorrect = TimeTunesAMQPProviders.hasRightAnswer();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );



    _controller.forward();
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/leaderboard');
      }
    });

    TimeTunesAMQPProviders.setCallback(null);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deck = TimeTunesAMQPProviders.getCurrentGameState()?.deck ?? [];
    final trackId = TimeTunesAMQPProviders.getCurrentGameState()?.round.trackId;

    final Music? music = deck.where((m) => m.trackId == trackId).isNotEmpty
        ? deck.firstWhere((m) => m.trackId == trackId)
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const SizedBox(
          width: double.infinity,
          child: Text(
            "TIMETUNES",
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: music == null
            ? const Text(
                "❌ Une erreur est survenue. Aucune chanson trouvée.",
                style: TextStyle(color: Colors.red, fontSize: 18),
                textAlign: TextAlign.center,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isCorrect
                        ? Icons.check_circle_outline
                        : Icons.highlight_off,
                    color: _isCorrect ? Colors.greenAccent : Colors.redAccent,
                    size: 100,
                  ),
                  const SizedBox(height: 24),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      music.albumCoverURL,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.black26,
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    music.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    music.artist,
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${music.releaseDate.year}",
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 25,)
                ],
              ),
      ),
    );
  }
}
