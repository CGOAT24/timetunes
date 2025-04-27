import 'package:flutter/material.dart';
import 'package:lexo_rank/lexo_rank.dart';

import '../../models/game_state.dart';
import '../../models/music.dart';
import '../../providers/timetune_amqp_providers.dart';
import '../../providers/timetunes_rest_providers.dart';
import '../../services/spotify_services.dart';
import '../../widgets/guess/guess_button_widget.dart';
import '../../widgets/guess/musics_list_widget.dart';

class GuessScreen extends StatefulWidget {
  const GuessScreen({super.key});

  @override
  State<GuessScreen> createState() => _GuessScreenState();
}

class _GuessScreenState extends State<GuessScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  List<Music> musics = TimeTunesAMQPProviders.getCurrentGameState()?.deck ?? [];
  int musicIndex = -1;
  bool canDrag = true;

  String _getLexorank() {
    if (musicIndex < 0) musicIndex = musics.length;
    String newLexoRank;
    if (musicIndex == 0) {
      newLexoRank = LexoRank.parse(musics[0].orderRank).genPrev().value;
    } else if (musicIndex == musics.length) {
      newLexoRank = LexoRank.parse(musics.last.orderRank).genNext().value;
    } else {
      final before = LexoRank.parse(musics[musicIndex - 1].orderRank);
      final after = LexoRank.parse(musics[musicIndex].orderRank);
      newLexoRank = before.between(after).value;
    }

    return newLexoRank;
  }

  void _submitAnswer() async {
    setState(() {
      canDrag = false;
    });

    GameState? state = TimeTunesAMQPProviders.getCurrentGameState();
    await TimeTunesRESTProvider.submitAnswer(state?.id ?? "",
        state?.round.id ?? "", _getLexorank(), TimeTunesAMQPProviders.userId);
  }

  void _reset(GameState state) {
    Navigator.of(context).pushReplacementNamed('/answer');
  }

  void _leave(BuildContext context) async {
    final shouldLeave = await showDialog<bool>(
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
                textStyle: const TextStyle(color: Colors.black)),
            child: const Text(
              "Quitter",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );

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

  @override
  void initState() {
    TimeTunesAMQPProviders.setCallback(_reset);
    GameState? state = TimeTunesAMQPProviders.getCurrentGameState();
    if (state != null) {
      SpotifyServices.playTrack(state.round.trackId);

      _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 58),
      );

      _controller.forward();
    }
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {}
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "TIMETUNES",
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () => _leave(context), icon: const Icon(Icons.logout)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: GuessButtonWidget(_submitAnswer),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "Insérer et placer la chanson à la bonne période",
            style: TextStyle(color: Colors.white, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => LinearProgressIndicator(
                value: _controller.value,
                backgroundColor: Colors.white10,
                color: Colors.orange,
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
              child: MusicsListWidget(
            musics: musics,
            round: TimeTunesAMQPProviders.getCurrentGameState()!.round,
            canDrag: canDrag,
            onRoundDropped: (index) {
              musicIndex = index;
            },
          )),
        ],
      ),
    );
  }
}
