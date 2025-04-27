import 'package:flutter/material.dart';

import '../../models/playlist.dart';

class PlaylistsSuggestionWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function createGame;

  const PlaylistsSuggestionWidget(this.controller, this.createGame,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          width: double.infinity,
          child: Text(
            "Recherche rapide",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: [
            "Reggae",
            "Pop",
            "Jazz",
            "Rock",
            "Country",
            "Classical",
            "Hip Hop"
          ].map((genre) {
            return GestureDetector(
              onTap: () => controller.text = genre,
              child: Chip(
                label: Text(genre),
                backgroundColor: Colors.grey[850],
                labelStyle: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        const SizedBox(
          width: double.infinity,
          child: Text(
            "Listes de lecture par Timetunes",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.3,
            ),
            itemCount: Playlist.basicPlaylists.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () =>
                    createGame(context, Playlist.basicPlaylists[index].id),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(Playlist.basicPlaylists[index].imageUrl,
                          fit: BoxFit.cover),
                      Container(
                        color: Colors.black26,
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          Playlist.basicPlaylists[index].name,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
