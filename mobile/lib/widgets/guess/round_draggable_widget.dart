import 'package:flutter/material.dart';

import '../../models/music.dart';
import '../../models/round.dart';

class RoundDraggableItem extends StatelessWidget {
  final Round round;
  final bool dragging;
  final int index;
  final List<Music> musics;
  final bool canDrag;

  const RoundDraggableItem(
      {super.key,
      required this.round,
      this.dragging = false,
      required this.index,
      required this.musics,
      this.canDrag = true});

  String getRangeLabel() {
    if (index == 0 && musics.isNotEmpty) {
      return '< ${musics.first.releaseDate.year}';
    } else if (index == musics.length && musics.isNotEmpty) {
      return '> ${musics.last.releaseDate.year}';
    } else if (index > 0 && index < musics.length) {
      final before = musics[index - 1].releaseDate.year;
      final after = musics[index].releaseDate.year;
      return '$before - $after';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final Widget widget = Container(
      height: 70,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: dragging ? Colors.transparent : Colors.deepPurple[400],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amberAccent, width: 2),
        boxShadow: dragging
            ? [
                const BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]
            : [],
      ),
      child: Row(
        children: [
          const Icon(Icons.touch_app, color: Colors.amber, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Placez ce morceau",
                  style: TextStyle(color: Colors.amber, fontSize: 14),
                ),
                if (!dragging)
                  Text(
                    getRangeLabel(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
              ],
            ),
          ),
        ],
      ),
    );

    if (!canDrag) return widget;

    return LongPressDraggable<int>(
      data: index,
      feedback: Material(
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 200, maxWidth: 300),
          child: widget,
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: widget),
      child: widget,
    );
  }
}
