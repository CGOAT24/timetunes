import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../widgets/join_game_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/videos/background.mp4")
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.setVolume(0);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToSettings(BuildContext context) {
    Navigator.pushNamed(context, "/settings");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "TIMETUNES",
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () => _goToSettings(context),
              icon: const Icon(Icons.settings))
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          if (_controller.value.isInitialized)
            SizedBox.expand(
                child: FittedBox(
              fit: BoxFit.cover,
              child: Transform.translate(
                offset: const Offset(
                    -50, 0),
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [JoinGameWidget()],
              ),
            ),
          )
        ],
      ),
    );
  }
}
