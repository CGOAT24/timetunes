import 'package:flutter/material.dart';

class SpotifyLoginButtonController {
  late void Function() enable;
  late void Function() disable;
}

class SpotifyLoginButton extends StatefulWidget {
  final Function onPressed;
  final SpotifyLoginButtonController? controller;
  const SpotifyLoginButton(this.onPressed, {this.controller, super.key});

  @override
  State<SpotifyLoginButton> createState() => _SpotifyLoginButtonState();
}

class _SpotifyLoginButtonState extends State<SpotifyLoginButton> {
  bool _isEnable = true;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      widget.controller!.enable = _enableButton;
      widget.controller!.disable = _disableButton;
    }
  }

  void _enableButton() {
    setState(() {
      _isEnable = true;
    });
  }

  void _disableButton() {
    setState(() {
      _isEnable = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isEnable ? () => widget.onPressed(context) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1DB954),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/spotify-logo.png',
              height: 24,
            ),
            const SizedBox(width: 10),
            const Text(
              'Se connecter avec Spotify',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
