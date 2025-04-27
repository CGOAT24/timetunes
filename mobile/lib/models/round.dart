class Round {
  final String id;
  final String trackId;
  final DateTime? startTime;
  final int index;

  Round({
    required this.id,
    required this.trackId,
    required this.startTime,
    required this.index,
  });

  factory Round.fromJson(Map<String, dynamic> json) {
    return Round(
      id: json['id'],
      trackId: json['trackId'],
      startTime: json['startTime'] == null ? null :DateTime.parse(json['startTime']),
      index: json['index'],
    );
  }
}
