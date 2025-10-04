import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoLoadingScreen extends StatefulWidget {
  const VideoLoadingScreen({Key? key}) : super(key: key);

  @override
  State<VideoLoadingScreen> createState() => _VideoLoadingScreenState();
}

class _VideoLoadingScreenState extends State<VideoLoadingScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initVideo;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/JCloadingscreen.mp4');
    _initVideo = _controller.initialize().then((_) {
      _controller.setLooping(true);
      _controller.play();
    }); // <- Only play after init!
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: _initVideo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            );
          } else {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
        },
      ),
    );
  }
}
