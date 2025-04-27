class Music {
  final String id;
  final String trackId;
  final String albumCoverURL;
  final String orderRank;
  final String gameId;
  final bool hidden;
  final String title;
  final String artist;
  final DateTime releaseDate;

  Music({
    required this.id,
    required this.trackId,
    required this.albumCoverURL,
    required this.orderRank,
    required this.gameId,
    required this.hidden,
    required this.title,
    required this.artist,
    required this.releaseDate,
  });

  factory Music.fromJson(Map<String, dynamic> json) {
    final List images = json['albumCovers'] ?? [];
    final String albumCoverURL =
        images.isNotEmpty ? images.first['url'] ?? '' : '';
    return Music(
      id: json['id'] ?? '',
      trackId: json['trackId'] ?? '',
      albumCoverURL: albumCoverURL,
      orderRank: json['orderRank'] ?? '',
      gameId: json['gameId'] ?? '',
      hidden: json['hidden'] ?? false,
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      releaseDate:
          DateTime.tryParse(json['releaseDate'] ?? '') ?? DateTime(1900),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trackId': trackId,
      'albumCoverURL': albumCoverURL,
      'orderRank': orderRank,
      'gameId': gameId,
      'hidden': hidden,
      'title': title,
      'artist': artist,
      'releaseDate': releaseDate.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Music(title: $title, artist: $artist, year: ${releaseDate.year})';
  }
}
