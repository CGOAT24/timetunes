import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/playlist.dart';
import '../../providers/timetunes_rest_providers.dart';
import 'playlist_item_widget.dart';
import 'playlists_suggestion_widget.dart';
import 'searchbar_playlist_widget.dart';

class SearchPlaylistWidget extends StatefulWidget {
  final Function(BuildContext context, String playlistId) createGame;

  const SearchPlaylistWidget(this.createGame, {super.key});

  @override
  State<SearchPlaylistWidget> createState() => _SearchPlaylistWidgetState();
}

class _SearchPlaylistWidgetState extends State<SearchPlaylistWidget> {
  final TextEditingController _controller = TextEditingController();

  List<Playlist> playlists = [];
  Timer? _debounce;

  void _onSearchChanged() async {
    if (_controller.text.isEmpty) return;
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      playlists = await TimeTunesRESTProvider.getPlaylists(_controller.text);

      setState(() {});
    });
  }

  @override
  void initState() {
    _onSearchChanged();
    _controller.addListener(_onSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          floating: false,
          delegate: SearchBarDelegate(_controller),
        ),
        if (_controller.text.isEmpty)
          SliverFillRemaining(
            child: PlaylistsSuggestionWidget(_controller, widget.createGame),
          )
        else
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.2,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => GestureDetector(
                onTap: () => widget.createGame(context, playlists[index].id),
                child: PlaylistItemWidget(playlists[index]),
              ),
              childCount: playlists.length,
            ),
          ),
      ],
    );
  }
}
