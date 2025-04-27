import 'package:flutter/material.dart';

import '../../models/music.dart';

class MusicItemWidget extends StatelessWidget {
  final Music music;
  final bool dragging;

  const MusicItemWidget(
      {super.key, required this.music, this.dragging = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white12,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            music.albumCoverURL,
            height: 50,
            width: 50,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(width: 50, height: 50, color: Colors.grey),
          ),
        ),
        title: Text(music.title,
            style: const TextStyle(color: Colors.white, fontSize: 16), maxLines: 2, overflow: TextOverflow.ellipsis,),
        subtitle: Text(
          music.artist,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        trailing: Text("${music.releaseDate.year}",
            style: const TextStyle(color: Colors.orange, fontSize: 16), maxLines: 2, overflow: TextOverflow.ellipsis,),
      ),
    );
  }
}
