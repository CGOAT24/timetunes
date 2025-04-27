import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import 'log_services.dart';

class SpotifyServices {
  static final String _clientId = dotenv.env['SPOTIFY_CLIENT_ID'] ?? "";

  static Future<void> playTrack(String trackId) async {
    final spotifyUri = 'spotify:track:$trackId';
    try {
      final isConnected = await SpotifySdk.connectToSpotifyRemote(
        clientId: _clientId,
        redirectUrl: 'timetunes://login',
      );

      if (!isConnected) {
        return;
      }

      await SpotifySdk.play(spotifyUri: spotifyUri);
      await SpotifySdk.setRepeatMode(repeatMode: RepeatMode.track);
    } catch (e) {
      LogService.logError("Spotify error while playing music: $e");
    }
  }

  static Future<void> stop() async {
    try {
      await SpotifySdk.pause();
      await SpotifySdk.disconnect();
    } catch (e) {
      LogService.logError("An error occurred with Spotify during disconnection: $e");
    }
  }

  static Future<String?> login() async {
    try {
      return await SpotifySdk.getAccessToken(
          clientId: _clientId,
          redirectUrl: "timetunes://login",
          scope:
              "app-remote-control,user-read-playback-state,user-modify-playback-state");
    } catch (e) {
      LogService.logError("Error during Spotify connection: $e");
      return null;
    }
  }
}
