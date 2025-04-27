import 'package:flutter/material.dart';

import '../models/game.dart';
import '../providers/timetunes_rest_providers.dart';
import '../widgets/search/search_playlist_widget.dart';
import 'gameloop/invite_player_screen.dart';

class CreateGameScreen extends StatelessWidget {

  const CreateGameScreen({super.key});

  void _createGame(BuildContext context, String playlistId) async {
    Game? game = await TimeTunesRESTProvider.createGame(playlistId);

    if (game != null && context.mounted) {
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => InvitePlayerScreen(game),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer une partie"),
      ),
      body: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: SearchPlaylistWidget(_createGame))),
    );
  }
}
