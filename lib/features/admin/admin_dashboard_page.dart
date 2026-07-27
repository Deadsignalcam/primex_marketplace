import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../widgets/primex_video_player.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int tab = 0;

  final tabs = const [
    'Listings',
    'Live Feed',
    'Ads',
    'Users',
    'Jobs/Services',
    'AI Assistant',
    'Payments',
    'Reports',
  ];

  final collections = const [
    'listings',
    'live_feed_posts',
    'paid_homepage_ads',
    'users',
    'job_service_leads',
    'ai_assistant_admin',
    'payments',
    'reports',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('PrimeX Admin Dashboard'),
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
          color: Colors.black.withOpacity(.45),
          child: Column(
            children: [
              SizedBox(
                height: 58,
                child: ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: tabs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final active = tab == i;
                    return ChoiceChip(
                      selected: active,
                      label: Text(tabs[i]),
                      selectedColor: const Color(0xFF00E5FF),
                      backgroundColor: const Color(0xFF061125),
                      labelStyle: TextStyle(
                        color: active ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (_) => setState(() => tab = i),
                    );
                  },
                ),
              ),
              Expanded(
                child: _AdminCollectionView(
                  title: tabs[tab],
                  collection: collections[tab],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminCollectionView extends StatelessWidget {
  final String title;
  final String collection;

  const _AdminCollectionView({
    required this.title,
    required this.collection,
  });

  bool isVideo(String s) {
    final t = s.toLowerCase();
    return t.contains('mp4') ||
        t.contains('mov') ||
        t.contains('webm') ||
        t.contains('m4v');
  }

  String imageFrom(Map<String, dynamic> d) {
    if (d['imageUrls'] is List && (d['imageUrls'] as List).isNotEmpty) {
      return (d['imageUrls'] as List).first.toString();
    }
    return (d['mediaUrl'] ?? d['photoURL'] ?? '').toString();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(collection)
          .orderBy('createdAt', descending: true)
          .limit(100)
          .snapshots(),
      builder: (context, snap) {
        if (snap.hasError) {
          return _empty('No data yet or index missing for $title.');
        }

        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snap.data!.docs;

        if (docs.isEmpty) {
          return _empty('No $title data yet.');
        }

        return GridView.builder(
          padding: const EdgeInsets.all(14),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 330,
            mainAxisExtent: 330,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final doc = docs[i];
            final data = doc.data() as Map<String, dynamic>;

            final name = (data['title'] ??
                    data['reason'] ??
                    data['displayName'] ??
                    data['name'] ??
                    data['text'] ??
                    data['description'] ??
                    'PrimeX Record')
                .toString();

            final media = imageFrom(data);
            final mediaType =
                (data['mediaType'] ?? data['videoUrl'] ?? '').toString();
            final owner = (data['displayName'] ??
                    data['reporterName'] ??
                    'Syntax Phantom')
                .toString();
            final ownerPhoto = (data['photoURL'] ?? '').toString();

            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF061125).withOpacity(.86),
                borderRadius: BorderRadius.circular(16),
                border:
                    Border.all(color: const Color(0xFF00E5FF).withOpacity(.70)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: media.isEmpty
                        ? const Icon(Icons.admin_panel_settings,
                            color: Color(0xFF00E5FF), size: 48)
                        : isVideo(mediaType)
                            ? PrimeXVideoPlayer(url: media)
                            : Image.network(media, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: const Color(0xFF00E5FF),
                        backgroundImage: ownerPhoto.isEmpty
                            ? null
                            : NetworkImage(ownerPhoto),
                        child: ownerPhoto.isEmpty
                            ? const Icon(Icons.person,
                                color: Colors.black, size: 14)
                            : null,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          owner,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'STATUS: ${(data['status'] ?? 'pending').toString().toUpperCase()}',
                    style: const TextStyle(
                      color: Colors.amberAccent,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.check_circle, size: 16),
                          label: const Text('Approve'),
                          onPressed: () {
                            doc.reference.set({
                              'status': 'approved',
                              'approvedAt': FieldValue.serverTimestamp(),
                            }, SetOptions(merge: true));
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.greenAccent,
                            side: const BorderSide(color: Colors.greenAccent),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.block, size: 16),
                          label: const Text('Ban'),
                          onPressed: () {
                            doc.reference.set({
                              'status': 'banned',
                              'bannedAt': FieldValue.serverTimestamp(),
                            }, SetOptions(merge: true));
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.orangeAccent,
                            side: const BorderSide(color: Colors.orangeAccent),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.delete, size: 16),
                          label: const Text('Delete'),
                          onPressed: () => doc.reference.delete(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                            side: const BorderSide(color: Colors.redAccent),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _empty(String text) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(18),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF061125).withOpacity(.86),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF00E5FF)),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ),
    );
  }
}
