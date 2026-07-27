import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/primex_follow_button.dart';
import '../feed/live_feed_page.dart';
import '../home/home_page.dart';
import '../map/map_page.dart';
import '../profile/profile_page.dart';

class PrimeXTrendsPage extends StatefulWidget {
  const PrimeXTrendsPage({super.key});

  @override
  State<PrimeXTrendsPage> createState() => _PrimeXTrendsPageState();
}

class _PrimeXTrendsPageState extends State<PrimeXTrendsPage> {
  String selected = 'All';

  List<String> media(dynamic v) {
    if (v is List) {
      return v
          .map((e) => e.toString())
          .where((e) => e.trim().isNotEmpty)
          .toList();
    }
    if (v is String && v.trim().isNotEmpty) return [v.trim()];
    return [];
  }

  Future<List<Map<String, dynamic>>> loadTrends() async {
    final all = <Map<String, dynamic>>[];

    Future<void> pull(String collection, String type) async {
      try {
        final snap = await FirebaseFirestore.instance
            .collection(collection)
            .limit(40)
            .get();

        for (final doc in snap.docs) {
          final d = doc.data();
          d['_id'] = doc.id;
          d['_type'] = type;

          final status = (d['status'] ?? '').toString().toLowerCase();
          final paymentStatus =
              (d['paymentStatus'] ?? '').toString().toLowerCase();
          final rejected = status == 'rejected' ||
              status == 'declined' ||
              d['rejected'] == true;

          if (rejected) continue;
          if (type == 'Ad' &&
              !(paymentStatus == 'paid' && d['approved'] == true)) continue;

          all.add(d);
        }
      } catch (_) {}
    }

    await pull('posts', 'Post');
    await pull('listings', 'Listing');
    await pull('ads_promotions', 'Ad');
    await pull('jobs_services', 'Service');

    all.sort((a, b) {
      final ba = (a['isBoosted'] == true || a['boostRank'] == 999999) ? 1 : 0;
      final bb = (b['isBoosted'] == true || b['boostRank'] == 999999) ? 1 : 0;
      return bb.compareTo(ba);
    });

    if (selected == 'All') return all;

    return all.where((x) {
      final type = (x['_type'] ?? '').toString().toLowerCase();
      final category = (x['category'] ?? '').toString().toLowerCase();
      final title = (x['title'] ?? x['text'] ?? '').toString().toLowerCase();
      final s = selected.toLowerCase();
      return type.contains(s) || category.contains(s) || title.contains(s);
    }).toList();
  }

  Widget background() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/primex_trends_bg.png',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(color: Colors.black),
        ),
        Container(color: Colors.black.withOpacity(.48)),
      ],
    );
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
      child: Row(
        children: [
          Image.asset(
            'assets/images/primex_logo.png',
            width: 42,
            height: 42,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.bolt, color: Colors.cyanAccent, size: 34),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'PrimeX Trends',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryTabs() {
    final tabs = ['All', 'Listing', 'Property', 'Service', 'Post', 'Ad'];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final t = tabs[i];
          final active = selected == t;
          return ChoiceChip(
            selected: active,
            label: Text(t),
            selectedColor: Colors.cyanAccent.withOpacity(.22),
            backgroundColor: Colors.black.withOpacity(.7),
            side:
                BorderSide(color: active ? Colors.cyanAccent : Colors.white24),
            labelStyle:
                TextStyle(color: active ? Colors.cyanAccent : Colors.white),
            onSelected: (_) => setState(() => selected = t),
          );
        },
      ),
    );
  }

  void openDetails(Map<String, dynamic> d) {
    final type = (d['_type'] ?? 'PrimeX').toString();
    final title =
        (d['title'] ?? d['text'] ?? d['caption'] ?? 'PrimeX Item').toString();
    final price = (d['price'] ?? '').toString();
    final details = (d['details'] ?? d['description'] ?? '').toString();
    final city = (d['city'] ?? '').toString();
    final state = (d['state'] ?? '').toString();
    final ownerId =
        (d['userId'] ?? d['ownerId'] ?? d['uid'] ?? d['sellerUid'] ?? '')
            .toString();
    final photos = [
      ...media(d['photoUrls']),
      ...media(d['imageUrls']),
      ...media(d['photos']),
      ...media(d['images']),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: .72,
          minChildSize: .35,
          maxChildSize: .92,
          builder: (context, controller) {
            return ListView(
              controller: controller,
              padding: const EdgeInsets.all(18),
              children: [
                Text(type.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                if (photos.isNotEmpty)
                  SizedBox(
                    height: 150,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: photos.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) => Container(
                        width: 150,
                        decoration: BoxDecoration(
                          color: const Color(0xFF061125),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: Colors.cyanAccent.withOpacity(.4)),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.network(photos[i], fit: BoxFit.contain),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold)),
                if (price.isNotEmpty)
                  Text('\$$price',
                      style: const TextStyle(
                          color: Colors.amberAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                if (city.isNotEmpty || state.isNotEmpty)
                  Text('$city $state',
                      style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 12),
                if (details.isNotEmpty)
                  Text(details, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 16),
                if (ownerId.isNotEmpty) PrimeXFollowButton(ownerId: ownerId),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> reactTrend(Map<String, dynamic> d, String emoji) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login first to react.')),
      );
      return;
    }

    final id = (d['_id'] ?? '').toString();
    final type = (d['_type'] ?? 'trend').toString().toLowerCase();
    if (id.isEmpty) return;

    final collection = type == 'Listing'
        ? 'listings'
        : type == 'Ad'
            ? 'ads_promotions'
            : type == 'Service'
                ? 'jobs_services'
                : 'posts';

    await FirebaseFirestore.instance.collection(collection).doc(id).set({
      'trendReactions': {
        user.uid: emoji,
      },
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reacted $emoji')),
    );
  }

  Future<void> reactTrendEmoji(Map<String, dynamic> d, String emoji) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login first to react.')),
      );
      return;
    }

    final id = (d['_id'] ?? '').toString();
    final type = (d['_type'] ?? 'trend').toString();
    if (id.isEmpty) return;

    try {
      final collection = type == 'Listing'
          ? 'listings'
          : type == 'Ad'
              ? 'ads_promotions'
              : type == 'Service'
                  ? 'jobs_services'
                  : 'posts';

      await FirebaseFirestore.instance.collection(collection).doc(id).set({
        'trendReactions': {
          user.uid: emoji,
        },
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reacted $emoji')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reaction failed: $e')),
      );
    }
  }

  Widget trendEmojiRow(Map<String, dynamic> d) {
    return Row(
      children: ['❤️', '🔥', '👏', '🙏'].map((e) {
        return InkWell(
          onTap: () => reactTrendEmoji(d, e),
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text(e, style: const TextStyle(fontSize: 20)),
          ),
        );
      }).toList(),
    );
  }

  Widget trendCard(Map<String, dynamic> d) {
    final type = (d['_type'] ?? 'PrimeX').toString();
    final title =
        (d['title'] ?? d['text'] ?? d['caption'] ?? 'PrimeX Item').toString();
    final price = (d['price'] ?? '').toString();
    final details = (d['details'] ?? d['description'] ?? '').toString();
    final city = (d['city'] ?? '').toString();
    final state = (d['state'] ?? '').toString();
    final ownerId =
        (d['userId'] ?? d['ownerId'] ?? d['uid'] ?? d['sellerUid'] ?? '')
            .toString();

    final photos = [
      ...media(d['photoUrls']),
      ...media(d['imageUrls']),
      ...media(d['photos']),
      ...media(d['images']),
    ];

    final photo = photos.isNotEmpty ? photos.first : '';
    final boosted = d['isBoosted'] == true || d['boostRank'] == 999999;
    final sponsored = type == 'Ad';

    return InkWell(
      onTap: () => openDetails(d),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.74),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.cyanAccent.withOpacity(.45)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 105,
                  width: double.infinity,
                  color: const Color(0xFF061125),
                  child: photo.startsWith('http')
                      ? Image.network(photo, fit: BoxFit.contain)
                      : const Icon(Icons.storefront,
                          color: Colors.cyanAccent, size: 48),
                ),
                Positioned(
                  left: 8,
                  top: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.78),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.cyanAccent),
                    ),
                    child: Text(
                      sponsored
                          ? 'SPONSORED'
                          : boosted
                              ? 'BOOSTED'
                              : type.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.cyanAccent,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (ownerId.isNotEmpty) PrimeXFollowButton(ownerId: ownerId),
                  Text(title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                  if (price.isNotEmpty)
                    Text('\$$price',
                        style: const TextStyle(
                            color: Colors.cyanAccent,
                            fontWeight: FontWeight.bold)),
                  if (city.isNotEmpty || state.isNotEmpty)
                    Text('$city $state',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12)),
                  if (details.isNotEmpty)
                    Text(details,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 5),
                  trendEmojiRow(d),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      ...['❤️', '🔥', '👏', '🙏'].map((e) {
                        return InkWell(
                          onTap: () => reactTrend(d, e),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child:
                                Text(e, style: const TextStyle(fontSize: 17)),
                          ),
                        );
                      }),
                      const Spacer(),
                      InkWell(
                        onTap: () async {
                          await Clipboard.setData(ClipboardData(
                              text: 'PrimeX Marketplace: $title'));
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Copied. Ready to share.')),
                          );
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.share, color: Colors.white70, size: 16),
                            SizedBox(width: 4),
                            Text('Share',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget trendGrid(List<Map<String, dynamic>> items) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 86),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 245,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: .66,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) => trendCard(items[i]),
    );
  }

  void goTo(Widget page, {bool replace = false}) {
    if (replace) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => page));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    }
  }

  Widget bottomNav() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: 72,
        color: Colors.black.withOpacity(.86),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _MiniNav(
                icon: Icons.home_outlined,
                label: 'Home',
                onTap: () => goTo(const HomePage(), replace: true)),
            _MiniNav(
                icon: Icons.dynamic_feed,
                label: 'Live Feed',
                onTap: () => goTo(const LiveFeedPage())),
            _MiniNav(
                icon: Icons.map_outlined,
                label: 'Map',
                onTap: () => goTo(const MapPage())),
            const _MiniNav(
                icon: Icons.trending_up, label: 'Trends', active: true),
            _MiniNav(
                icon: Icons.person_outline,
                label: 'Profile',
                onTap: () => goTo(const ProfilePage())),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          background(),
          SafeArea(
            child: Column(
              children: [
                header(),
                categoryTabs(),
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: loadTrends(),
                    builder: (context, snap) {
                      final items = snap.data ?? [];
                      if (items.isEmpty) {
                        return const Center(
                          child: Text('No trends yet.',
                              style: TextStyle(color: Colors.white70)),
                        );
                      }
                      return trendGrid(items);
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomNav(),
        ],
      ),
    );
  }
}

class _MiniNav extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const _MiniNav({
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? Colors.cyanAccent : Colors.white70;

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 23),
            const SizedBox(height: 3),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: active ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}
