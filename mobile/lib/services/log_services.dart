import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class LogService {
  static File? _logFile;
  static late Logger _logger;

  static Future<void> init() async {
    _logger = Logger();
    final directory = await getApplicationDocumentsDirectory();
    _logFile = File('${directory.path}/timetunes.log');
    if (!(await _logFile!.exists())) {
      await _logFile!.create();
    }
  }

  static Future<void> logError(String message) async {
    final String log = _logMessage(message);
    _logger.e(log);
    await _logFile?.writeAsString('$log\n', mode: FileMode.append);
  }

  static Future<void> log(String message) async {
    final String log = _logMessage(message);
    _logger.t(log);
    await _logFile?.writeAsString('$log\n', mode: FileMode.append);
  }

  static Future<String> readLog() async {
    return await _logFile?.readAsString() ?? '';
  }

  static Future<void> clearLog() async {
    await _logFile?.writeAsString('');
  }

  static String _logMessage(String message) {
    final timestamp = DateTime.now().toIso8601String();
    return '[$timestamp] $message';
  }
}
