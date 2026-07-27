import 'package:flutter/material.dart';

class PrimeXHomeItemDetailsPage extends StatelessWidget {
  const PrimeXHomeItemDetailsPage({
    super.key,
    required this.data,
    required this.type,
  });

  final Map<String, dynamic> data;
  final String type;

  @override
  Widget build(BuildContext context) {
    final title =
        (data['title'] ?? data['text'] ?? data['details'] ?? 'PrimeX Item')
            .toString();
    final desc = (data['description'] ??
            data['details'] ??
            data['listingDetails'] ??
            data['text'] ??
            '')
        .toString();
    final name = (data['displayName'] ??
            data['sellerName'] ??
            data['ownerName'] ??
            'Syntax Phantom')
        .toString();
    final avatar = (data['photoUrl'] ?? data['profilePhoto'] ?? '').toString();
    final price = (data['price'] ?? '').toString();
    final photos = List<String>.from(data['photoUrls'] ??
        data['imageUrls'] ??
        data['images'] ??
        data['photos'] ??
        []);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black, title: Text(type.toUpperCase())),
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset('assets/images/primex_jobs_bg.png',
                  fit: BoxFit.cover)),
          Positioned.fill(
              child: Container(color: Colors.black.withOpacity(.76))),
          ListView(
            padding: const EdgeInsets.all(14),
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.cyanAccent,
                    backgroundImage:
                        avatar.startsWith('http') ? NetworkImage(avatar) : null,
                    child: avatar.startsWith('http')
                        ? null
                        : const Icon(Icons.person, color: Colors.black),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (photos.isNotEmpty)
                SizedBox(
                  height: 260,
                  child: PageView(
                    children: photos
                        .map((p) => ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.network(p, fit: BoxFit.cover),
                            ))
                        .toList(),
                  ),
                ),
              const SizedBox(height: 14),
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900)),
              if (price.isNotEmpty)
                Text('\$$price',
                    style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 24,
                        fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              Text(desc,
                  style: const TextStyle(color: Colors.white70, height: 1.35)),
            ],
          ),
        ],
      ),
    );
  }
}
