import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static void setRestUrl(String url) {
    _prefs.setString("rest_url", url);
  }

  static void setAmqUrl(String url) {
    _prefs.setString("amq_url", url);
  }

  static void setAmqPort(int port) {
    _prefs.setInt("amq_port", port);
  }

  static String getRestUrl() {
    return _prefs.getString("rest_url") ?? "http://10.0.2.2:8000";
  }

  static String getAmqUrl() {
    return _prefs.getString("amq_url") ?? "10.0.2.2";
  }

  static int getAmqPort() {
    return _prefs.getInt("amq_port") ?? 5672;
  }
}
