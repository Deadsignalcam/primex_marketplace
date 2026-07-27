import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../listings/listing_details_page.dart';
import '../../widgets/primex_video_player.dart';

class PrimeXGlobalSearchPage extends StatefulWidget {
  const PrimeXGlobalSearchPage({super.key});

  @override
  State<PrimeXGlobalSearchPage> createState() => _PrimeXGlobalSearchPageState();
}

class _PrimeXGlobalSearchPageState extends State<PrimeXGlobalSearchPage> {
  String q = '';

  String imageFrom(Map<String, dynamic> d) {
    if (d['imageUrls'] is List && (d['imageUrls'] as List).isNotEmpty) {
      return (d['imageUrls'] as List).first.toString();
    }
    return (d['mediaUrl'] ?? '').toString();
  }

  bool isVideo(String s) {
    final t = s.toLowerCase();
    return t.contains('mp4') ||
        t.contains('mov') ||
        t.contains('webm') ||
        t.contains('m4v');
  }

  bool match(Map<String, dynamic> d) {
    if (q.trim().isEmpty) return true;
    final text = [
      d['title'],
      d['text'],
      d['description'],
      d['category'],
      d['city'],
      d['state'],
      d['country'],
      d['displayName'],
      d['plan'],
    ].join(' ').toLowerCase();
    return text.contains(q.toLowerCase());
  }

  void openListingDetails(Map<String, dynamic> d) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ListingDetailsPage(
          listingId: (d['id'] ?? '').toString(),
          data: d,
        ),
      ),
    );
  }

  Widget resultCard(Map<String, dynamic> d, String label) {
    final mediaUrl = imageFrom(d);
    final mediaType = (d['mediaType'] ?? d['videoUrl'] ?? '').toString();

    return GestureDetector(
        onTap: label == 'LISTING' ? () => openListingDetails(d) : null,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF061125).withOpacity(.78),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF00E5FF)),
          ),
          child: Row(
            children: [
              Container(
                width: 86,
                height: 86,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24),
                ),
                child: mediaUrl.isEmpty
                    ? const Icon(Icons.search,
                        color: Color(0xFF00E5FF), size: 38)
                    : isVideo(mediaType)
                        ? PrimeXVideoPlayer(url: mediaUrl)
                        : Image.network(mediaUrl, fit: BoxFit.cover),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: const TextStyle(
                              color: Color(0xFF00E5FF),
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                      Text(
                        (d['title'] ?? d['text'] ?? 'PrimeX Result').toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${d['city'] ?? ''} ${d['state'] ?? ''} ${d['plan'] ?? ''}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12),
                      ),
                    ]),
              ),
            ],
          ),
        ));
  }

  Widget streamBlock(String title, String collection, String label) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(collection)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) return const SizedBox.shrink();

        final docs = snap.data!.docs
            .map((x) => x.data() as Map<String, dynamic>)
            .where(match)
            .toList();

        if (docs.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...docs.map((d) => resultCard(d, label)),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Search PrimeX'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/primex_home_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(.32),
          child: ListView(
            padding: const EdgeInsets.all(14),
            children: [
              TextField(
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                onChanged: (v) => setState(() => q = v),
                decoration: InputDecoration(
                  hintText: 'Search listings, ads, posts, jobs, services...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFF00E5FF)),
                  filled: true,
                  fillColor: Colors.black.withOpacity(.55),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF00E5FF)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        const BorderSide(color: Color(0xFF00E5FF), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              streamBlock('Listings', 'listings', 'LISTING'),
              streamBlock('Live Posts', 'live_feed_posts', 'LIVE POST'),
              streamBlock('Paid Ads', 'paid_homepage_ads', 'PAID AD'),
            ],
          ),
        ),
      ),
    );
  }
}
