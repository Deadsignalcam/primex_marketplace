import 'package:flutter/material.dart';

import '../../widgets/primex_profile_contact_bar.dart';

class MapPinDetailPage extends StatelessWidget {
  const MapPinDetailPage({super.key, required this.data});

  final Map<String, dynamic> data;

  List<String> allPhotos() {
    final out = <String>[];

    void add(dynamic value) {
      if (value is String && value.startsWith('http')) out.add(value);
      if (value is List) {
        for (final x in value) {
          if (x is String && x.startsWith('http')) out.add(x);
        }
      }
    }

    add(data['photoUrls']);
    add(data['imageUrls']);
    add(data['images']);
    add(data['photos']);
    add(data['bannerUrls']);
    add(data['mediaUrls']);
    add(data['thumbnail']);
    add(data['imageUrl']);

    return out.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    final title = (data['title'] ?? data['text'] ?? 'PrimeX Item').toString();
    final details = (data['details'] ??
            data['description'] ??
            data['listingDetails'] ??
            data['text'] ??
            '')
        .toString();
    final name = (data['displayName'] ??
            data['sellerName'] ??
            data['ownerName'] ??
            'Syntax Phantom')
        .toString();
    final avatar =
        (data['photoUrl'] ?? data['profilePhoto'] ?? data['sellerPhoto'] ?? '')
            .toString();
    final price = (data['price'] ?? '').toString();
    final address = (data['address'] ?? data['location'] ?? '').toString();
    final photos = allPhotos();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar:
          AppBar(backgroundColor: Colors.black, title: const Text('Details')),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/primex_jobs_bg.png',
                fit: BoxFit.cover),
          ),
          Positioned.fill(
              child: Container(color: Colors.black.withOpacity(.76))),
          ListView(
            padding: const EdgeInsets.all(14),
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: Colors.cyanAccent,
                    backgroundImage:
                        avatar.startsWith('http') ? NetworkImage(avatar) : null,
                    child: avatar.startsWith('http')
                        ? null
                        : const Icon(Icons.person,
                            color: Colors.black, size: 38),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              PrimeXProfileContactBar(profile: data),
              const SizedBox(height: 14),
              if (photos.isNotEmpty) ...[
                SizedBox(
                  height: 280,
                  child: PageView(
                    children: photos.map((url) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(
                          url,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.black54,
                            child: const Icon(Icons.broken_image,
                                color: Colors.white),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 70,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: photos.map((url) {
                      return Container(
                        width: 70,
                        height: 70,
                        margin: const EdgeInsets.only(right: 8),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.cyanAccent),
                        ),
                        child: Image.network(url, fit: BoxFit.cover),
                      );
                    }).toList(),
                  ),
                ),
              ],
              const SizedBox(height: 14),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (price.isNotEmpty)
                Text(
                  '\$$price',
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              if (address.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(address,
                      style: const TextStyle(color: Colors.cyanAccent)),
                ),
              const SizedBox(height: 12),
              Text(details,
                  style: const TextStyle(color: Colors.white70, height: 1.35)),
            ],
          ),
        ],
      ),
    );
  }
}
