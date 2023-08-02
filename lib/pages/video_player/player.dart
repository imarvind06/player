import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Player extends StatefulWidget {
  final String videoUrl;
  const Player({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
        videoPlayerController.setLooping(true);
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  int tapCount = 0;
  bool playIconVisible = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        setState(() {
          tapCount++;
        });
        if (tapCount % 2 == 0) {
          videoPlayerController.play();
          setState(() {
            playIconVisible = true;
          });
        } else {
          videoPlayerController.pause();
          setState(() {
            playIconVisible = false;
          });
        }
      },
      child: Container(
        height: size.height,
        width: size.width,
        color: Colors.white,
        child: Stack(alignment: Alignment.topRight, children: [
          VideoPlayer(videoPlayerController),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: (playIconVisible)
                  ? const Icon(Icons.play_circle_outline_rounded)
                  : const Icon(Icons.pause_circle_outline_outlined),
            ),
          ),
        ]),
      ),
    );
  }
}
