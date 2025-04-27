class Player {
  final String id;
  final String username;
  final String profileURL;
  final List<String>? images;

  Player(
      {required this.id,
      required this.username,
      required this.profileURL,
      required this.images});

  factory Player.fromJson(Map<String, dynamic> json) {
    List<dynamic>? rawImages = json['profilePictures'];
    List<String>? cleanImages;

    if (rawImages != null) {
      cleanImages = rawImages
          .where((img) => img != null && img is Map && img['url'] != null)
          .map((img) => img['url'].toString())
          .toList();
    }

    return Player(
      id: json['id'],
      username: json['username'] ?? json['display_name'],
      profileURL: json['profileURL'] ?? json['href'],
      images: cleanImages,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'profileURL': profileURL,
      'images': images,
    };
  }

  String get profileImageUrl {
    if (images != null && images!.isNotEmpty) {
      return images![0];
    }
    return "https://ui-avatars.com/api/?background=f57921&color=fffff&name=${username.replaceAll(" ", "+")}";
  }
}
