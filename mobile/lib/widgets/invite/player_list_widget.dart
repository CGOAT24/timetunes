import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/game_state.dart';
import '../../models/player.dart';
import '../../providers/timetune_amqp_providers.dart';
import '../../providers/timetunes_rest_providers.dart';

// ignore: must_be_immutable
class PlayerListWidget extends StatefulWidget {
  List<Player> players;
  final String pin;

  PlayerListWidget(this.pin, this.players, {super.key});

  @override
  State<PlayerListWidget> createState() => _PlayerListWidgetState();
}

class _PlayerListWidgetState extends State<PlayerListWidget> {
  @override
  void initState() {
    TimeTunesAMQPProviders.setCallback(_updatePlayers);
    if (widget.players.isEmpty) {
      TimeTunesRESTProvider.getUserProfile().then((player) {
        if (player != null && widget.players.isEmpty) {
          setState(() {
            widget.players.add(player);
          });
        }
      });
    }
    super.initState();
  }

  void _updatePlayers(GameState gameState) {
    if (gameState.rounds[0].startTime != null) {
      Navigator.of(context).pushReplacementNamed('/guess');
    } else {
      setState(() {
        widget.players = gameState.players;
      });
    }
  }

  void _share() {
    Share.share(
        "Hey ! 🚀 J'organise une session TimeTunes, et je veux que vous la rejoigniez ! NIP pour participer : ${widget.pin}");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Joueurs (${widget.players.length})",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            IconButton(onPressed: _share, icon: const Icon(Icons.share))
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.15,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.only(right: 35),
                child: Column(
                  children: [
                    ClipOval(
                      child: Image.network(
                        widget.players[index].profileImageUrl,
                        width: MediaQuery.of(context).size.height * 0.08,
                        height: MediaQuery.of(context).size.height * 0.08,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.players[index].username,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              );
            },
            itemCount: widget.players.length,
          ),
        )
      ],
    );
  }
}
