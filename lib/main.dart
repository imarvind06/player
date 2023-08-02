import 'package:flutter/material.dart';
import 'package:player/pages/video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VideoPlayer(),
    );
  }
}
