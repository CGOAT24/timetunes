import 'package:flutter/material.dart';

import '../../models/game.dart';
import '../../providers/timetune_amqp_providers.dart';
import '../../providers/timetunes_rest_providers.dart';
import '../../widgets/invite/player_list_widget.dart';
import '../../widgets/invite/playlist_description_widget.dart';

class InvitePlayerScreen extends StatelessWidget {
  final Game? game;

  InvitePlayerScreen(this.game, {super.key}) {
    TimeTunesAMQPProviders.joinGame(game?.brokerQueue ?? "");
  }

  void _startGame(BuildContext context) async {
    if (game != null) {
      await TimeTunesRESTProvider.startRound(game?.id ?? "");
    }
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
            ),
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
      await TimeTunesRESTProvider.leaveGame(game?.id ?? "");

      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "TIMETUNES",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () => _leave(context), icon: const Icon(Icons.logout)),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PlaylistDescriptionWidget(
                  game?.playlistId ?? "", game?.pin ?? ""),
              PlayerListWidget(game?.pin ?? "", game?.players ?? []),
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _startGame(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Commencer',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
