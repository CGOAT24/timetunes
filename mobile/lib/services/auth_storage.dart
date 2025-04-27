import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveTokens(String accessToken) async {
    await _storage.write(key: 'access_token', value: accessToken);
  }

  static Future<void> saveSpotifyToken(String spotifyToken) async {
    await _storage.write(key: 'spotify_token', value: spotifyToken);
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  static Future<String?> getSpotifyToken() async {
    return await _storage.read(key: 'spotify_token');
  }

  static Future<bool> isConnected() async {
    return _storage.containsKey(key: 'access_token');
  }

  static Future<void> clearToken() async {
    await _storage.deleteAll();
  }
}
