class Playlist {
  final String id;
  final String name;
  final String description;
  final String imageUrl;

  static List<Playlist> basicPlaylists = [
    Playlist(
        id: "037jD11y7Fi23sVPUvaD8P",
        name: "Billboard Hot 100",
        description: "",
        imageUrl: "assets/images/thumbnail-100billboard.jpg"),
    Playlist(
        id: "47FRXhWfC9tepdhBdWwP24",
        name: "Rap & Hip-Hop",
        description: "",
        imageUrl: "assets/images/thumbnail-rap.jpg"),
    Playlist(
        id: "2pH97DTUEkfNUeIn63bUyb",
        name: "Rock Légendaire",
        description: "",
        imageUrl: "assets/images/thumbnail-rock.jpg"),
    Playlist(
        id: "5sROBI90MGwh2Bw7BkdWoT",
        name: "Classique Québécois",
        description: "",
        imageUrl: "assets/images/thumbnail-qc.jpg"),
    Playlist(
        id: "7jW7XoRNpu61fq91J6oQ2q",
        name: "Metal",
        description: "",
        imageUrl: "assets/images/thumbnail-metal.jpg"),
    Playlist(
        id: "5pydmtuPjvCi4h3r7gkRL9",
        name: "Meilleur Reprise",
        description: "",
        imageUrl: "assets/images/thumbnail-cover.jpg")
  ];

  Playlist({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  /// Factory method pour créer un objet Playlist à partir d'un JSON
  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Sans nom',
      description: json['description'] ?? '',
      imageUrl: (json['images'] != null && json['images'].isNotEmpty)
          ? json['images'][0]['url']
          : '',
    );
  }

  /// Convertit l'objet Playlist en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  @override
  String toString() {
    return 'Playlist(id: $id, name: $name, description: $description, imageUrl: $imageUrl)';
  }
}
