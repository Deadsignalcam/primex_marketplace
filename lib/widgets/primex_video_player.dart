import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PrimeXVideoPlayer extends StatefulWidget {
  final String url;
  const PrimeXVideoPlayer({super.key, required this.url});

  @override
  State<PrimeXVideoPlayer> createState() => _PrimeXVideoPlayerState();
}

class _PrimeXVideoPlayerState extends State<PrimeXVideoPlayer> {
  VideoPlayerController? controller;
  bool failed = false;

  @override
  void initState() {
    super.initState();

    if (widget.url.trim().isEmpty || !widget.url.startsWith('http')) {
      failed = true;
      return;
    }

    controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));

    controller!.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    }).catchError((_) {
      if (!mounted) return;
      setState(() => failed = true);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (failed) {
      return Container(
        height: 120,
        width: 160,
        color: Colors.black,
        child: const Center(
          child: Text(
            'Video not supported',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ),
      );
    }

    final c = controller;
    if (c == null || !c.value.isInitialized) {
      return Container(
        height: 120,
        width: 160,
        color: Colors.black,
        child: const Center(
            child: CircularProgressIndicator(color: Color(0xFF00E5FF))),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          c.value.isPlaying ? c.pause() : c.play();
        });
      },
      child: SizedBox(
        height: 120,
        width: 160,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: c.value.aspectRatio,
              child: VideoPlayer(c),
            ),
            if (!c.value.isPlaying)
              const Icon(Icons.play_circle_fill,
                  color: Color(0xFF00E5FF), size: 42),
          ],
        ),
      ),
    );
  }
}
