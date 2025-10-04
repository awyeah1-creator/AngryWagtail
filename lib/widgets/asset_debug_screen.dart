import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class AssetDebugScreen extends StatefulWidget {
  const AssetDebugScreen({Key? key}) : super(key: key);

  @override
  State<AssetDebugScreen> createState() => _AssetDebugScreenState();
}

class _AssetDebugScreenState extends State<AssetDebugScreen> {
  late VideoPlayerController _videoController;
  late Future<void> _videoInit;
  String iconStatus = 'Pending';
  String audioStatus = 'Pending';
  String videoStatus = 'Pending';

  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.asset('algbra-assets/video/JCloadingscreen.mp4');

    // Video asset - load bytes first, then initialize player
    rootBundle
        .load('algbra-assets/video/JCloadingscreen.mp4')
        .then((bytes) {
      debugPrint('[ASSET DEBUG] Video asset bytes loaded: ${bytes.lengthInBytes}');
      videoStatus = 'Asset bytes: ${bytes.lengthInBytes}';
      setState(() {});
      _videoInit = _videoController.initialize().then((_) {
        _videoController.setLooping(true);
        _videoController.play();
        videoStatus = 'Player loaded!';
        debugPrint('[ASSET DEBUG] Video player initialized and playing.');
        setState(() {});
      });
    }).catchError((e) {
      videoStatus = 'Asset error: $e';
      debugPrint('[ASSET DEBUG] Video asset load failed: $e');
      setState(() {});
    });

    _checkIcon();
    _checkAudio();
  }

  Future<void> _checkIcon() async {
    try {
      final bytes = await rootBundle.load('algbra-assets/icons/wagtail_icon.png');
      iconStatus = 'Loaded (${bytes.lengthInBytes} bytes)';
      debugPrint('[ASSET DEBUG] Icon loaded - bytes: ${bytes.lengthInBytes}');
      setState(() {});
    } catch (e) {
      iconStatus = 'Error: $e';
      debugPrint('[ASSET DEBUG] Icon load failed: $e');
      setState(() {});
    }
  }

  Future<void> _checkAudio() async {
    try {
      final bytes = await rootBundle.load('algbra-assets/audio/wagtail-chirp4.mp3');
      audioStatus = 'Loaded (${bytes.lengthInBytes} bytes)';
      debugPrint('[ASSET DEBUG] Audio loaded - bytes: ${bytes.lengthInBytes}');
      setState(() {});
    } catch (e) {
      audioStatus = 'Error: $e';
      debugPrint('[ASSET DEBUG] Audio load failed: $e');
      setState(() {});
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modern Asset Debug Screen')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Icon Status: $iconStatus'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Audio Status: $audioStatus'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Video Status: $videoStatus'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: _videoInit,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      _videoController.value.isInitialized) {
                    return AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: VideoPlayer(_videoController),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Video Error: ${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
