import 'package:flutter/material.dart';

import '../providers/timetunes_rest_providers.dart';
import '../services/log_services.dart';
import '../services/spotify_services.dart';
import '../widgets/login/spotify_login_button_widget.dart';

class LoginScreen extends StatelessWidget {
  final SpotifyLoginButtonController _spotifyBtnController =
      SpotifyLoginButtonController();

  LoginScreen({super.key});

  void _login(BuildContext context) async {
    _spotifyBtnController.disable();

    String? accessToken = await SpotifyServices.login();

    if (accessToken == null) {
      if (context.mounted) {
        const snackBar = SnackBar(
            content: Text(
                "Une erreur s'est produite lors de la connexion à Spotify. Veuillez réessayer plus tard"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      bool isConnected = await TimeTunesRESTProvider.login(accessToken);
      if (isConnected && context.mounted) {
        LogService.log("The login has been successfully completed");
        Navigator.pushReplacementNamed(context, "/home");
      } else if (context.mounted) {
        const snackBar = SnackBar(
            content: Text(
                "Une erreur s'est produite lors de la connexion. Veuillez réessayer plus tard"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    _spotifyBtnController.enable();
  }

  void _goToSettings(BuildContext context) {
    Navigator.pushNamed(context, "/settings");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg-login.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: FractionallySizedBox(
              widthFactor: 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "TIMETUNES",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: 40),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Teste ta mémoire musicale, deviens le maître du temps",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w500, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 200),
                  Column(
                    children: [
                      SpotifyLoginButton(_login,
                          controller: _spotifyBtnController),
                      TextButton(
                          onPressed: () => _goToSettings(context),
                          child: const Text("Paramètres",
                              style: TextStyle(color: Colors.white54)))
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
