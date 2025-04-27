import 'dart:convert';

import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/game_state.dart';
import '../services/log_services.dart';
import '../services/settings_services.dart';

class TimeTunesAMQPProviders {
  static final String _host = SettingsService.getAmqUrl();
  static final int _port = SettingsService.getAmqPort();
  static GameState? _gameState;
  static Function? _callback;
  static Client? _client;
  static String _userId = "";

  static int _previousScore = 0;

  static Future<bool> joinGame(String brokerQueue) async {
    final String username = dotenv.env['AMQ_USERNAME'] ?? "";
    final String password = dotenv.env['AMQ_PASSWORD'] ?? "";
    final settings = ConnectionSettings(
      host: _host,
      port: _port,
      authProvider: PlainAuthenticator(username, password),
    );
    _client?.close();
    Client client = Client(settings: settings);
    _client = client;

    try {
      Channel channel = await client.channel();
      Queue queue = await channel.queue(brokerQueue);
      _userId = brokerQueue;

      Consumer consumer =
          await queue.consume(consumerTag: brokerQueue, noAck: true);

      consumer.listen((AmqpMessage message) {
        LogService.log("A new GameState has been received from AMQ");
        _previousScore = _gameState?.scoreBoard.getCurrentScore().score ?? 0;
        _gameState = GameState.fromJson(
            Map<String, dynamic>.from(jsonDecode(message.payloadAsString)));
        _callback?.call(_gameState);
      });

      LogService.log("AMQ connection has been successfully completed");

      return true;
    } catch (e) {
      LogService.logError("An error has occurred during AMQ connection: $e");
      return false;
    }
  }

  static void leave() {
    _client?.close();
  }

  static GameState? getCurrentGameState() {
    return _gameState;
  }

  static void setCallback(Function? callback) {
    _callback = callback;
  }

  static bool hasRightAnswer() {
    if (_gameState == null) {
      return false;
    }
    int score = _gameState?.scoreBoard.getCurrentScore().score ?? 0;
    bool isCorrect = score > _previousScore;

    return isCorrect;
  }

  static String get userId {
    return _userId;
  }
}
