import 'package:flutter/material.dart';
import '../providers/timetunes_rest_providers.dart';

import '../models/game.dart';
import '../screens/gameloop/invite_player_screen.dart';

class JoinGameWidget extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  JoinGameWidget({super.key});

  void _createGame(BuildContext context) {
    Navigator.pushNamed(context, "/create");
  }

  void _joinGame(BuildContext context) async {
    if (_controller.text.length != 4) {
      const snackBar = SnackBar(
          content: Text("Le code pin doit être composé de 4 caractères."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      Game? game = await TimeTunesRESTProvider.joinGame(_controller.text);
      if(context.mounted){
        if (game != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InvitePlayerScreen(game),
          ),
        );
      } else {
        const snackBar = SnackBar(
            content: Text(
                "Nous n'avons pas trouvé le jeu. Vérifiez votre code pin."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      }
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            maxLength: 4,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              hintText: "Quelle est le pin du jeu ?",
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _joinGame(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Rejoindre',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextButton(
                onPressed: () => _createGame(context),
                child: const Text("Créer une partie"))
          ],
        ),
      ),
    );
  }
}
