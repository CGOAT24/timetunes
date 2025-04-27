import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:timetunes/services/settings_services.dart';

import 'screens/create_game_screen.dart';
import 'screens/gameloop/answer_reveal_screen.dart';
import 'screens/gameloop/guess_song_screen.dart';
import 'screens/gameloop/invite_player_screen.dart';
import 'screens/gameloop/leaderboard_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/settings_screen.dart';
import 'services/auth_storage.dart';
import 'services/log_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LogService.init();
  await dotenv.load();
  await SettingsService.init();

  runApp(const TimeTunes());
}

class TimeTunes extends StatelessWidget {
  const TimeTunes({super.key});

  Future<String> _getInitialRoute() async {
    return await AuthStorage.isConnected() ? "/home" : "/login";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TimeTunes',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFf57921),
            secondary: Colors.white,
          ),
          textTheme: ThemeData.dark()
              .textTheme
              .apply(fontFamily: "SourceCodePro")
              .copyWith(
                  titleLarge: const TextStyle(fontFamily: "MontserratAlt1"))),
      themeMode: ThemeMode.dark,
      home: FutureBuilder<String>(
        future: _getInitialRoute(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, snapshot.data!);
          });

          return const Scaffold();
        },
      ),
      routes: {
        "/home": (context) => const HomeScreen(),
        "/login": (context) => LoginScreen(),
        "/create": (context) => const CreateGameScreen(),
        "/invite": (context) => InvitePlayerScreen(null),
        "/guess": (context) => const GuessScreen(),
        "/answer": (context) => const AnswerRevealScreen(),
        "/leaderboard": (context) => const LeaderboardScreen(),
        "/settings": (context) => const SettingsScreen(),
      },
    );
  }
}
