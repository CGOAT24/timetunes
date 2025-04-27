import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/playlist.dart';
import '../../providers/timetunes_rest_providers.dart';

class PlaylistDescriptionWidget extends StatefulWidget {
  final String playlistId;
  final String pin;

  const PlaylistDescriptionWidget(this.playlistId, this.pin, {super.key});

  @override
  State<PlaylistDescriptionWidget> createState() =>
      _PlaylistDescriptionWidgetState();
}

class _PlaylistDescriptionWidgetState extends State<PlaylistDescriptionWidget> {
  Playlist? _playlist;

  @override
  void initState() {
    TimeTunesRESTProvider.getPlaylist(widget.playlistId).then((playlist) {
      setState(() {
        _playlist = playlist;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withAlpha(25),
                spreadRadius: 3,
                blurRadius: 10,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: _playlist != null
                  ? FadeInImage.assetNetwork(
                      placeholder: "assets/images/playlist-placeholder.jpeg",
                      image: _playlist?.imageUrl ?? "",
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.width * 0.8,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 500),
                      fadeInCurve: Curves.easeInOut,
                    )
                  : Image.asset(
                      "assets/images/playlist-placeholder.jpeg",
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.width * 0.8,
                      fit: BoxFit.cover,
                    )),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          _playlist?.name ?? "...",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "PIN Code: ",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16),
            ),
            GestureDetector(
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: widget.pin));

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Code pin copié dans le presse-papiers")));
                }
              },
              child: Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.white, width: 0.7))),
                  child: Text(
                    widget.pin,
                    style: const TextStyle(fontSize: 16),
                  )),
            )
          ],
        )
      ],
    );
  }
}
