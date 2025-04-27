import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/game.dart';
import '../models/player.dart';
import '../models/playlist.dart';
import '../services/auth_storage.dart';
import '../services/log_services.dart';
import '../services/settings_services.dart';

class TimeTunesRESTProvider {
  static final String baseUrl = SettingsService.getRestUrl();
  static http.Client? _client;
  static Player? profile;
  static String createdGameId = "";

  static Future<bool> checkServerStatus() async {
    try {
      final response = await _getClient()
          .get(Uri.parse('$baseUrl/api/ping'))
          .timeout(const Duration(seconds: 3));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> login(String spotifyToken) async {
    try {
      AuthStorage.saveSpotifyToken(spotifyToken);
      final headers = {"Content-Type": "application/json"};

      final body = jsonEncode({
        "access_token": spotifyToken,
        "expires_in": 3600,
        "refresh_token": "abc123def456ghi789",
        "token_type": "Bearer"
      });

      final response = await http
          .post(Uri.parse('$baseUrl/api/auth'), headers: headers, body: body)
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        AuthStorage.saveTokens(jsonDecode(response.body));
        return true;
      }
    } catch (e) {
      LogService.logError(
          "An error occurred while authenticating with TimeTunes: $e");
      return false;
    }
    return false;
  }

  static Future<List<Playlist>> getPlaylists(String? q) async {
    try {
      String? token = await AuthStorage.getAccessToken();

      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };

      final response = await _getClient()
          .get(Uri.parse("$baseUrl/api/playlists?q=$q"), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        return data
            .where((data) => data != null)
            .map((json) => Playlist.fromJson(json))
            .toList();
      }
    } catch (e) {
      LogService.logError(
          "An error occurred during a request for a playlist search: $e");
    }

    return [];
  }

  static Future<Game?> createGame(String playlistId) async {
    try {
      String? token = await AuthStorage.getAccessToken();

      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };

      final body = jsonEncode(
          {"playlistId": playlistId, "roundCount": 10, "startingCardCount": 1});

      final response = await _getClient()
          .post(Uri.parse("$baseUrl/api/game"), headers: headers, body: body);

      if (response.statusCode == 200) {
        Game game = Game.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
        createdGameId = game.id;
        return game;
      }
    } catch (e) {
      LogService.logError(
          "An error occurred during a request to create a game: $e");
    }

    return null;
  }

  static Future<Player?> getUserProfile() async {
    String? token = await AuthStorage.getAccessToken();
    if (token == null) {
      profile = null;
      return null;
    }
    if (profile != null) return profile;
    try {
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };

      final response = await _getClient()
          .get(Uri.parse("$baseUrl/api/auth/profile"), headers: headers);

      if (response.statusCode == 200) {
        profile = Player.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
        return profile;
      }
    } catch (e) {
      LogService.logError(
          "An error occurred during a request to retrieve the profile: $e");
    }

    return null;
  }

  static Future<Game?> joinGame(String pin) async {
    try {
      String? token = await AuthStorage.getAccessToken();

      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };

      final response = await _getClient()
          .patch(Uri.parse("$baseUrl/api/game/$pin"), headers: headers);

      if (response.statusCode == 200) {
        return Game.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      }
    } catch (e) {
      LogService.logError(
          "An error occurred during a request to join a game: $e");
    }

    return null;
  }

  static Future<bool?> startRound(String gameId) async {
    try {
      String? token = await AuthStorage.getAccessToken();

      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };

      final response = await _getClient().post(
          Uri.parse("$baseUrl/api/game/$gameId/startRound"),
          headers: headers);

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      LogService.logError(
          "An error occurred during a request to start a new round: $e");
    }

    return false;
  }

  static Future<Playlist?> getPlaylist(String playlistId) async {
    try {
      String? token = await AuthStorage.getAccessToken();

      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };

      final response = await http.Client().get(
          Uri.parse("$baseUrl/api/playlists/$playlistId"),
          headers: headers);

      if (response.statusCode == 200) {
        return Playlist.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      }
    } catch (e) {
      LogService.logError(
          "An error occurred during a request to retrieve information from a playlist: $e");
    }

    return null;
  }

  static Future<bool?> submitAnswer(
      String gameId, String roundId, String lexoRank, String userId) async {
    try {
      String? token = await AuthStorage.getAccessToken();

      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };

      final body = jsonEncode({"userId": userId, "position": lexoRank});

      final response = await _getClient().patch(
          Uri.parse("$baseUrl/api/game/$gameId/round/$roundId"),
          body: body,
          headers: headers);

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      LogService.logError(
          "An error occurred during a request to submit a answer: $e");
    }

    return false;
  }

  static Future<bool?> leaveGame(String gameId) async {
    try {
      String? token = await AuthStorage.getAccessToken();

      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };

      final response = await _getClient()
          .delete(Uri.parse("$baseUrl/api/game/$gameId"), headers: headers);

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      LogService.logError(
          "An error occurred during a request to quit a game: $e");
    }

    return false;
  }

  static http.Client _getClient() {
    _client?.close();
    http.Client client = http.Client();
    _client = client;
    return client;
  }
}
