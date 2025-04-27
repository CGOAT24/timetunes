import 'package:flutter/material.dart';

import '../../models/music.dart';

class DragTargetWidget extends StatelessWidget {
  final int index;
  final List<Music> musics;

  const DragTargetWidget({
    super.key,
    required this.index,
    required this.musics,
  });

  @override
  Widget build(BuildContext context) {
    String rangeLabel = '';

    if (index == 0 && musics.isNotEmpty) {
      rangeLabel = '< ${musics.first.releaseDate.year}';
    } else if (index == musics.length && musics.isNotEmpty) {
      rangeLabel = '> ${musics.last.releaseDate.year}';
    } else if (index > 0 && index < musics.length) {
      final before = musics[index - 1].releaseDate.year;
      final after = musics[index].releaseDate.year;
      rangeLabel = '$before - $after';
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.amber, width: 2),
        borderRadius: BorderRadius.circular(12),
        color: Colors.amber[25],
      ),
      child: Center(
        child: Text(
          rangeLabel,
          style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
