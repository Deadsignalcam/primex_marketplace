import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PrimeXHomeAdVideoBox extends StatefulWidget {
  const PrimeXHomeAdVideoBox({super.key});

  @override
  State<PrimeXHomeAdVideoBox> createState() => _PrimeXHomeAdVideoBoxState();
}

class _PrimeXHomeAdVideoBoxState extends State<PrimeXHomeAdVideoBox> {
  late final VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.asset('assets/videos/primex_home_ad.mp4')
      ..initialize().then((_) {
        controller.setLooping(true);
        controller.setVolume(0);
        controller.play();
        if (mounted) setState(() {});
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const SizedBox(
        height: 160,
        child:
            Center(child: CircularProgressIndicator(color: Color(0xFF00E5FF))),
      );
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF00E5FF)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}
