import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PrimeXLiveAdsBox extends StatelessWidget {
  const PrimeXLiveAdsBox({super.key});

  String image(Map<String, dynamic> x) {
    if ((x['imageUrl'] ?? '').toString().isNotEmpty)
      return x['imageUrl'].toString();
    if ((x['bannerUrl'] ?? '').toString().isNotEmpty)
      return x['bannerUrl'].toString();
    if (x['imageUrls'] is List && (x['imageUrls'] as List).isNotEmpty)
      return (x['imageUrls'] as List).first.toString();
    return '';
  }

  String video(Map<String, dynamic> x) {
    for (final k in ['videoUrl', 'adVideoUrl', 'mediaUrl', 'clipUrl']) {
      final v = (x[k] ?? '').toString();
      if (v.isNotEmpty) return v;
    }
    if (x['videoUrls'] is List && (x['videoUrls'] as List).isNotEmpty) {
      return (x['videoUrls'] as List).first.toString();
    }
    return '';
  }

  void openAd(BuildContext context, Map<String, dynamic> x) {
    final title =
        (x['title'] ?? x['businessName'] ?? x['packageName'] ?? 'PrimeX Ad')
            .toString();
    final img = image(x);
    final vid = video(x);
    final paid = x['paid'] == true ||
        x['paymentStatus'] == 'paid' ||
        x['status'] == 'active';

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF0B1020),
        child: SizedBox(
          width: 620,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                if (vid.isNotEmpty)
                  PrimeXAdVideoPlayer(videoUrl: vid)
                else if (img.isNotEmpty)
                  Image.network(img,
                      height: 260, width: double.infinity, fit: BoxFit.cover)
                else
                  const Icon(Icons.campaign,
                      color: Colors.cyanAccent, size: 80),
                const SizedBox(height: 10),
                Text(
                  paid ? 'ACTIVE / LIVE' : 'PENDING PAYMENT',
                  style: TextStyle(
                      color: paid ? Colors.greenAccent : Colors.amberAccent,
                      fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('ads_promotions')
          .orderBy('createdAt', descending: true)
          .limit(30)
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData)
          return const Center(child: CircularProgressIndicator());

        final docs = snap.data!.docs;
        if (docs.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: 145,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final x = docs[i].data() as Map<String, dynamic>;
              final img = image(x);
              final vid = video(x);
              final title = (x['title'] ??
                      x['businessName'] ??
                      x['packageName'] ??
                      'PrimeX Ad')
                  .toString();
              final paid = x['paid'] == true ||
                  x['paymentStatus'] == 'paid' ||
                  x['status'] == 'active';

              return InkWell(
                onTap: () => openAd(context, x),
                child: Container(
                  width: 165,
                  margin: const EdgeInsets.all(6),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B1020),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: paid ? Colors.cyanAccent : Colors.amberAccent),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (img.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(img,
                              height: 58,
                              width: double.infinity,
                              fit: BoxFit.cover),
                        )
                      else
                        Container(
                          height: 58,
                          alignment: Alignment.center,
                          child: Icon(
                              vid.isNotEmpty
                                  ? Icons.play_circle
                                  : Icons.campaign,
                              color: Colors.cyanAccent,
                              size: 28),
                        ),
                      const SizedBox(height: 6),
                      Text(title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11)),
                      Text(
                        paid ? 'LIVE AD' : 'PENDING PAYMENT',
                        style: TextStyle(
                            color:
                                paid ? Colors.greenAccent : Colors.amberAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 10),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class PrimeXAdVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const PrimeXAdVideoPlayer({
    super.key,
    required this.videoUrl,
  });

  @override
  State<PrimeXAdVideoPlayer> createState() => _PrimeXAdVideoPlayerState();
}

class _PrimeXAdVideoPlayerState extends State<PrimeXAdVideoPlayer> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
        controller.play();
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
        height: 260,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Column(
      children: [
        AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              color: Colors.cyanAccent,
              icon: Icon(
                  controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () {
                setState(() {
                  controller.value.isPlaying
                      ? controller.pause()
                      : controller.play();
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
