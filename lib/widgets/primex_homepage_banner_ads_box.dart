import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PrimeXHomepageBannerAdsBox extends StatelessWidget {
  const PrimeXHomepageBannerAdsBox({super.key});

  bool isPaid(Map<String, dynamic> x) {
    return x['paid'] == true ||
        x['paymentStatus'] == 'paid' ||
        x['status'] == 'active' ||
        x['isLive'] == true;
  }

  String image(Map<String, dynamic> x) {
    if ((x['imageUrl'] ?? '').toString().isNotEmpty)
      return x['imageUrl'].toString();
    if ((x['bannerUrl'] ?? '').toString().isNotEmpty)
      return x['bannerUrl'].toString();
    if (x['imageUrls'] is List && (x['imageUrls'] as List).isNotEmpty) {
      return (x['imageUrls'] as List).first.toString();
    }
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
        (x['title'] ?? x['businessName'] ?? 'PrimeX Banner Ad').toString();
    final img = image(x);
    final vid = video(x);

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF0B1020),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: SizedBox(
            width: 620,
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
                  _AdVideoPlayer(videoUrl: vid)
                else if (img.isNotEmpty)
                  Image.network(img,
                      height: 260, width: double.infinity, fit: BoxFit.cover)
                else
                  const Icon(Icons.campaign,
                      color: Colors.cyanAccent, size: 80),
                const SizedBox(height: 10),
                const Text('ACTIVE / LIVE HOMEPAGE BANNER',
                    style: TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold)),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1020),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.cyanAccent),
      ),
      child: Row(
        children: [
          const Icon(Icons.workspace_premium,
              color: Colors.cyanAccent, size: 42),
          const SizedBox(width: 12),
          const SizedBox(
            width: 230,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('HOMEPAGE BANNER AD',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                Text('Paid ads appear live inside this box',
                    style: TextStyle(color: Colors.cyanAccent, fontSize: 12)),
                Text('19.99',
                    style: TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('ads_promotions')
                  .orderBy('createdAt', descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (context, snap) {
                if (!snap.hasData)
                  return const Center(child: CircularProgressIndicator());

                final paidAds = snap.data!.docs.where((d) {
                  final x = d.data() as Map<String, dynamic>;
                  final kind =
                      (x['packageName'] ?? x['type'] ?? x['adType'] ?? '')
                          .toString()
                          .toLowerCase();
                  return isPaid(x) &&
                      (kind.contains('banner') ||
                          kind.contains('homepage') ||
                          kind.contains('ad'));
                }).toList();

                if (paidAds.isEmpty) {
                  return const Center(
                    child: Text('Paid homepage banner ads will appear here.',
                        style: TextStyle(color: Colors.white54)),
                  );
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: paidAds.length,
                  itemBuilder: (context, i) {
                    final x = paidAds[i].data() as Map<String, dynamic>;
                    final title =
                        (x['title'] ?? x['businessName'] ?? 'PrimeX Ad')
                            .toString();
                    final img = image(x);
                    final vid = video(x);

                    return InkWell(
                      onTap: () => openAd(context, x),
                      child: Container(
                        width: 135,
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111827),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.greenAccent),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (img.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(img,
                                    height: 62,
                                    width: double.infinity,
                                    fit: BoxFit.cover),
                              )
                            else
                              Container(
                                height: 62,
                                alignment: Alignment.center,
                                child: Icon(
                                    vid.isNotEmpty
                                        ? Icons.play_circle
                                        : Icons.campaign,
                                    color: Colors.cyanAccent,
                                    size: 30),
                              ),
                            const SizedBox(height: 5),
                            Text(title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold)),
                            const Text('LIVE',
                                style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AdVideoPlayer extends StatefulWidget {
  final String videoUrl;
  const _AdVideoPlayer({required this.videoUrl});

  @override
  State<_AdVideoPlayer> createState() => _AdVideoPlayerState();
}

class _AdVideoPlayerState extends State<_AdVideoPlayer> {
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
          height: 260, child: Center(child: CircularProgressIndicator()));
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: VideoPlayer(controller),
    );
  }
}
