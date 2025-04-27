import 'package:flutter/material.dart';
import '../../models/music.dart';
import '../../models/round.dart';
import 'drag_target_widget.dart';
import 'music_item_widget.dart';
import 'round_draggable_widget.dart';

class MusicsListWidget extends StatefulWidget {
  final List<Music> musics;
  final Round round;
  final Function(int) onRoundDropped;
  final bool canDrag;

  const MusicsListWidget({
    super.key,
    required this.musics,
    required this.round,
    required this.onRoundDropped,
    required this.canDrag
  });

  @override
  State<MusicsListWidget> createState() => _MusicsListState();
}

class _MusicsListState extends State<MusicsListWidget> {
  int? roundIndex;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        for (int i = 0; i < widget.musics.length; i++) ...[
          DragTarget<int>(
            onWillAcceptWithDetails: (_) => true,
            onAcceptWithDetails: (_) {
              setState(() => roundIndex = i);
              widget.onRoundDropped(i);
            },
            builder: (context, candidateData, rejectedData) {
              return Column(
                children: [
                  if (candidateData.isNotEmpty)
                    DragTargetWidget(index: i, musics: widget.musics),
                  if (roundIndex == i)
                    RoundDraggableItem(
                      round: widget.round,
                      index: i,
                      musics: widget.musics,
                      dragging: false,
                      canDrag: widget.canDrag,
                    ),
                  MusicItemWidget(music: widget.musics[i]),
                ],
              );
            },
          ),
        ],
        DragTarget<int>(
          onWillAcceptWithDetails: (_) => true,
          onAcceptWithDetails: (_) {
            setState(() => roundIndex = widget.musics.length);
            widget.onRoundDropped(widget.musics.length);
          },
          builder: (context, candidateData, rejectedData) {
            final showRound =
                roundIndex == widget.musics.length || roundIndex == null;

            return Column(
              children: [
                if (candidateData.isNotEmpty)
                  DragTargetWidget(
                      index: widget.musics.length, musics: widget.musics),
                if (showRound)
                  RoundDraggableItem(
                    round: widget.round,
                    index: widget.musics.length,
                    musics: widget.musics,
                    dragging: false,
                    canDrag: widget.canDrag,
                  )
                else
                  Container(
                    height: 60,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    alignment: Alignment.center,
                  ),
              ],
            );
          },
        ),
        SizedBox(height: MediaQuery.of(context).size.height*0.2,)
      ],
    );
  }
}
