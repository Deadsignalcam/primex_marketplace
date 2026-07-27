import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../widgets/primex_video_player.dart';

class PrimeXHomeRightAdsBox extends StatelessWidget {
  const PrimeXHomeRightAdsBox({super.key});

  bool isVideo(String type) {
    final t = type.toLowerCase();
    return t.contains('mp4') ||
        t.contains('mov') ||
        t.contains('webm') ||
        t.contains('m4v');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.38),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00E5FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('PAID PROMOTIONS',
              style: TextStyle(
                  color: Color(0xFF00E5FF),
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
          const SizedBox(height: 6),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('paid_homepage_ads')
                .orderBy('createdAt', descending: true)
                .limit(4)
                .snapshots(),
            builder: (context, snap) {
              if (!snap.hasData || snap.data!.docs.isEmpty) {
                return const Text('No ads yet.',
                    style: TextStyle(color: Colors.white70, fontSize: 11));
              }

              return Column(
                children: snap.data!.docs.map((doc) {
                  final d = doc.data() as Map<String, dynamic>;
                  final mediaUrl = (d['mediaUrl'] ?? '').toString();
                  final mediaType = (d['mediaType'] ?? '').toString();
                  final title = (d['title'] ?? 'Paid Ad').toString();

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF061125).withOpacity(.72),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 76,
                          width: double.infinity,
                          child: mediaUrl.isEmpty
                              ? const Icon(Icons.campaign,
                                  color: Color(0xFF00E5FF))
                              : isVideo(mediaType)
                                  ? PrimeXVideoPlayer(url: mediaUrl)
                                  : ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(10)),
                                      child: Image.network(mediaUrl,
                                          fit: BoxFit.cover),
                                    ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
