import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../widgets/primex_home_people_listing_feed.dart';
import '../../services/primex_sound_service.dart';
import '../post/primex_post_hub_page.dart';
import '../map/map_page.dart';
import '../jobs/jobs_services_page.dart';
import '../listings/listings_page.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget panel(Widget child) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xDD07101D),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF00E5FF)),
        ),
        child: child,
      );

  Widget browseBubble(BuildContext context, IconData icon, String label) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () => openBrowseTab(context, label),
      child: bubble(icon, label),
    );
  }

  Widget bubble(IconData icon, String label) => Container(
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xCC050A12),
          border: Border.all(color: const Color(0xFF00E5FF), width: 2),
          boxShadow: const [
            BoxShadow(color: Color(0x7700E5FF), blurRadius: 12)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF00E5FF), size: 20),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 8)),
          ],
        ),
      );

  Widget bannerAds() => panel(
        const Row(
          children: [
            Icon(Icons.workspace_premium, color: Color(0xFF00E5FF), size: 48),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('HOMEPAGE BANNER AD',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  Text('Get Maximum Exposure For Your Business',
                      style: TextStyle(color: Color(0xFF00E5FF))),
                  Text('19.99',
                      style: TextStyle(
                          color: Color(0xFF00E5FF),
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      );

  Widget hubCard(IconData icon, String title, String number, Color color) =>
      Expanded(
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              Text(title,
                  style: const TextStyle(color: Colors.white70, fontSize: 11)),
              Text(number,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              const Text('Active Listings',
                  style: TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
        ),
      );

  ImageProvider? avatarImage(String b64, String url) {
    if (b64.trim().isNotEmpty) {
      try {
        return MemoryImage(base64Decode(b64.trim()));
      } catch (_) {}
    }
    if (url.trim().isNotEmpty) return NetworkImage(url.trim());
    return null;
  }

  Widget userCircle(String uid, String savedB64, String savedUrl) {
    if (uid.trim().isEmpty) {
      final img = avatarImage(savedB64, savedUrl);
      return CircleAvatar(
        radius: 22,
        backgroundColor: const Color(0xFF101522),
        backgroundImage: img,
        child: img == null
            ? const Icon(Icons.person, color: Color(0xFF00E5FF))
            : null,
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('profiles')
          .doc(uid.trim())
          .snapshots(),
      builder: (context, snap) {
        final p = snap.data?.data() as Map<String, dynamic>?;
        final b64 = p?['avatarBase64']?.toString() ?? savedB64;
        final url = p?['photoUrl']?.toString() ?? savedUrl;
        final img = avatarImage(b64, url);

        return CircleAvatar(
          radius: 22,
          backgroundColor: const Color(0xFF101522),
          backgroundImage: img,
          child: img == null
              ? const Icon(Icons.person, color: Color(0xFF00E5FF))
              : null,
        );
      },
    );
  }

  Widget mediaStrip(List imgs) {
    if (imgs.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 92,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: imgs.map((u) {
          return Padding(
            padding: const EdgeInsets.only(right: 8, top: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                u.toString(),
                width: 92,
                height: 92,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 92,
                  height: 92,
                  color: Colors.black,
                  child: const Icon(Icons.image_not_supported,
                      color: Colors.redAccent),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget liveFeed() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('live_feed').snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) return const SizedBox();

        final docs = snap.data!.docs
            .where((d) {
              final x = d.data() as Map<String, dynamic>;
              return x['status'] != 'deleted' && x['status'] != 'hidden';
            })
            .take(4)
            .toList();

        return Column(
          children: docs.map((d) {
            final x = d.data() as Map<String, dynamic>;
            final imgs = List.from(x['imageUrls'] ?? []);
            final video = x['videoUrl']?.toString() ?? '';

            return panel(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      userCircle(
                        x['userId']?.toString() ?? '',
                        x['avatarBase64']?.toString() ?? '',
                        x['photoUrl']?.toString() ?? '',
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          x['displayName']?.toString() ?? 'Syntax Phantom',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const SizedBox(height: 12),
                  Text(x['text']?.toString() ?? '',
                      style: const TextStyle(color: Colors.white70)),
                  mediaStrip(imgs),
                  if (video.isNotEmpty)
                    TextButton.icon(
                      onPressed: () => launchUrl(Uri.parse(video),
                          mode: LaunchMode.externalApplication),
                      icon: const Icon(Icons.play_circle,
                          color: Color(0xFF00E5FF)),
                      label: const Text('Open Video',
                          style: TextStyle(color: Color(0xFF00E5FF))),
                    ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget liveAdsPromotions() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection('ads_promotions').snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) return const SizedBox();

        final ads = snap.data!.docs
            .where((d) {
              final x = d.data() as Map<String, dynamic>;
              return (x['paymentStatus'] == 'paid' || x['paid'] == true) &&
                  (x['status'] == 'active' || x['status'] == 'approved') &&
                  x['showOnHome'] != false;
            })
            .take(5)
            .toList();

        if (ads.isEmpty) {
          return panel(
            const Row(
              children: [
                Icon(Icons.campaign, color: Color(0xFF00E5FF), size: 34),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'LIVE ADS & PROMOTIONS\nPaid banners, business spotlights, clips, and promos will appear here.',
                    style: TextStyle(
                        color: Colors.white70, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        }

        return panel(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('LIVE ADS & PROMOTIONS',
                  style: TextStyle(
                      color: Color(0xFF00E5FF),
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(
                height: 105,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: ads.map((d) {
                    final x = d.data() as Map<String, dynamic>;
                    final imgs = List.from(
                        x['imageUrls'] ?? x['bannerUrls'] ?? x['images'] ?? []);
                    final title = x['title']?.toString() ??
                        x['businessName']?.toString() ??
                        'PrimeX Promotion';
                    final video = x['videoUrl']?.toString() ?? '';

                    return Container(
                      width: 210,
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.65),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFF00E5FF)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (imgs.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                imgs.first.toString(),
                                width: 190,
                                height: 54,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 190,
                                  height: 54,
                                  color: Colors.black,
                                  child: const Icon(Icons.campaign,
                                      color: Color(0xFF00E5FF)),
                                ),
                              ),
                            )
                          else
                            Container(
                              width: 190,
                              height: 54,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.campaign,
                                  color: Color(0xFF00E5FF)),
                            ),
                          if (video.isNotEmpty && imgs.isEmpty)
                            Container(
                              height: 82,
                              width: 190,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.greenAccent),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.play_circle,
                                      color: Colors.greenAccent, size: 34),
                                  Text('VIDEO / CLIP',
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          const SizedBox(height: 6),
                          Text(title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          if (video.isNotEmpty)
                            const Text('Video promo available',
                                style: TextStyle(
                                    color: Color(0xFF00E5FF), fontSize: 11)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void openBrowseTab(BuildContext context, String tab) {
    if (tab == 'Real Estate') {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const MapPage()));
      return;
    }

    if (tab == 'Services' || tab == 'Jobs') {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const JobsServicesPage()));
      return;
    }

    if (tab == 'Buy & Sell') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => const ListingsPage(initialCategory: 'General')));
      return;
    }

    if (tab == 'Electronics') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  const ListingsPage(initialCategory: 'Electronics')));
      return;
    }

    if (tab == 'Fashion') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => const ListingsPage(initialCategory: 'Fashion')));
      return;
    }

    if (tab == 'Pets') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => const ListingsPage(initialCategory: 'Pets')));
      return;
    }

    if (tab == 'More') {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const PrimeXPostHubPage()));
      return;
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => const ListingsPage(initialCategory: 'General')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030812),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(14),
          children: [
            Row(
              children: const [
                Icon(Icons.menu, color: Colors.white, size: 30),
                Spacer(),
                IconButton(
                  icon: const Icon(Icons.notifications_none,
                      color: Colors.white, size: 30),
                  onPressed: PrimeXSoundService.bell,
                ),
                SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline,
                      color: Colors.white, size: 28),
                  onPressed: PrimeXSoundService.message,
                ),
              ],
            ),
            const Text('PRIME X',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 44,
                    fontWeight: FontWeight.w900)),
            const Text('MARKETPLACE',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFF00E5FF),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 5)),
            const Text('BUY | SELL | CONNECT | GROW',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, letterSpacing: 3)),
            const SizedBox(height: 10),
            panel(
              SizedBox(
                height: 430,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/primex_home_bg.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned.fill(
                        child: Container(color: Colors.black.withOpacity(.15))),
                    const Positioned(
                        left: 10,
                        top: 18,
                        child: Text('WELCOME TO',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold))),
                    const Positioned(
                        left: 10,
                        top: 48,
                        child: Text('PRIME X',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 42,
                                fontWeight: FontWeight.w900))),
                    const Positioned(
                        left: 10,
                        top: 98,
                        child: Text('The Ultimate Marketplace',
                            style: TextStyle(
                                color: Color(0xFF00E5FF),
                                fontSize: 12,
                                fontWeight: FontWeight.bold))),
                    const Positioned(
                        left: 10,
                        top: 132,
                        width: 190,
                        child: Text('Everything You Need.\nAll in One Place.',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                height: 1.35))),
                    Positioned(
                        left: 250,
                        top: 30,
                        child: bubble(Icons.phone_iphone, 'iPhone')),
                    Positioned(
                        left: 330,
                        top: 30,
                        child: bubble(Icons.directions_car, 'Cars')),
                    Positioned(
                        left: 410,
                        top: 30,
                        child: bubble(Icons.home, 'Property')),
                    Positioned(
                        left: 250,
                        top: 110,
                        child: bubble(Icons.laptop_mac, 'Laptops')),
                    Positioned(
                        left: 330,
                        top: 110,
                        child: bubble(Icons.build, 'Tools')),
                    Positioned(
                        left: 410,
                        top: 110,
                        child: bubble(Icons.diamond, 'Jewelry')),
                    Positioned(
                        left: 250,
                        top: 190,
                        child: bubble(Icons.sports_esports, 'Gaming')),
                    Positioned(
                        left: 330,
                        top: 190,
                        child: bubble(Icons.business, 'Commercial')),
                    const Positioned(
                      left: 10,
                      bottom: 20,
                      child: Text(
                        '👑 Matthew 6:33\nBut seek first the kingdom of God and His righteousness.',
                        style: TextStyle(
                            color: Color(0xFF00E5FF),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(children: [
              Expanded(child: bannerAds()),
              const SizedBox(width: 10),
              Expanded(
                  child: panel(const Text(
                      '👑 PRIMEX PRO\n49.99 dollars monthly\n✓ Leads  ✓ Foreclosures\n✓ Tax Sales  ✓ Comps\n✓ Title Companies  ✓ Offers',
                      style: TextStyle(
                          color: Color(0xFF00E5FF),
                          fontWeight: FontWeight.bold)))),
            ]),
            const Text('BROWSE EVERYTHING',
                style: TextStyle(
                    color: Color(0xFF00E5FF),
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [
              browseBubble(context, Icons.home, 'Real Estate'),
              browseBubble(context, Icons.directions_car, 'Vehicles'),
              bubble(Icons.handyman, 'Services'),
              browseBubble(context, Icons.work, 'Jobs'),
              browseBubble(context, Icons.shopping_cart, 'Buy & Sell'),
              browseBubble(context, Icons.devices, 'Electronics'),
              browseBubble(context, Icons.checkroom, 'Fashion'),
              browseBubble(context, Icons.pets, 'Pets'),
              browseBubble(context, Icons.more_horiz, 'More'),
            ]),
            const SizedBox(height: 14),
            const PrimeXHomePeopleListingFeed(),
            liveAdsPromotions(),
            const SizedBox(height: 14),
            const Text('MARKETPLACE HUB',
                style: TextStyle(
                    color: Color(0xFF00E5FF),
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(children: [
              hubCard(Icons.home, 'PROPERTIES', '1,246', Colors.greenAccent),
              hubCard(
                  Icons.directions_car, 'VEHICLES', '842', Colors.cyanAccent),
              hubCard(Icons.work, 'JOBS', '532', Colors.purpleAccent),
              hubCard(Icons.handshake, 'SERVICES', '1,215', Colors.amberAccent),
            ]),
            const SizedBox(height: 14),
            const Text('LIVE FEED',
                style: TextStyle(
                    color: Color(0xFF00E5FF),
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
            liveFeed(),
            const Text(
              'Powered by Syntax Phantom | Philippians 4:13 | © 2026 PrimeX Marketplace',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
