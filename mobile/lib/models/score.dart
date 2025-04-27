import '../providers/timetune_amqp_providers.dart';

class Score {
  final String userId;
  final int score;

  Score({required this.userId, required this.score});

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      userId: json['userId'],
      score: json['score'],
    );
  }
}

class ScoreBoard {
  final List<Score> _scores;

  ScoreBoard(List<Map<String, dynamic>> rawData)
      : _scores = rawData.map((e) => Score.fromJson(e)).toList() {
    _scores.sort((a, b) => b.score.compareTo(a.score));
  }

  List<Score> get scores => _scores;

  Score getScoreForUser(String userId) {
    return _scores.firstWhere(
      (score) => score.userId == userId,
      orElse: () => Score(userId: userId, score: 0),
    );
  }

  Score getCurrentScore() {
    return _scores.firstWhere(
      (score) => score.userId == TimeTunesAMQPProviders.userId,
      orElse: () =>
          Score(userId: TimeTunesAMQPProviders.userId, score: 0),
    );
  }

  int getCurrentRank() {
    final userId = TimeTunesAMQPProviders.userId;

    for (int i = 0; i < _scores.length; i++) {
      if (_scores[i].userId == userId) return i + 1;
    }

    return -1;
  }

  String getCurrentRankMessage() {
    final rank = getCurrentRank();
    if (rank == -1) return "Aucun classement disponible.";

    final total = _scores.length;

    if (rank == 1) {
      return "🥇 Vous êtes en tête du classement ! Roi du tempo !";
    }

    if (rank == total) {
      return "😅 Vous êtes en bas du classement... Encore une chance au prochain round !";
    }

    final percentage = ((total - rank) / total * 100).round();

    if (percentage >= 90) {
      return "Vous êtes dans le top 10% des meilleurs ! 🎉";
    } else if (percentage >= 75) {
      return "Excellente performance ! Top 25% ! 💪";
    } else if (percentage >= 50) {
      return "Vous êtes mieux classé que $percentage% des joueurs.";
    } else {
      return "Continuez, vous êtes classé dans les $percentage% !";
    }
  }
}
