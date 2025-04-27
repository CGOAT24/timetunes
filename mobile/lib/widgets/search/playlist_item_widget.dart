import 'package:flutter/material.dart';

import '../../models/playlist.dart';

class PlaylistItemWidget extends StatelessWidget {
  final Playlist playlist;

  const PlaylistItemWidget(this.playlist, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              FadeInImage.assetNetwork(
                placeholder: "assets/images/playlist-placeholder.jpeg",
                image: playlist.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                fadeInDuration: const Duration(milliseconds: 500),
                fadeInCurve: Curves.easeInOut,
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black45, 
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Text(
                playlist.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
