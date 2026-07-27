import 'package:flutter/material.dart';

class PrimeXListingPreviewCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onTap;

  const PrimeXListingPreviewCard({
    super.key,
    required this.data,
    this.onTap,
  });

  List<String> mediaList(dynamic v) {
    if (v is List) {
      return v.map((e) => e.toString()).where((e) => e.isNotEmpty).toList();
    }
    if (v is String && v.trim().isNotEmpty) return [v.trim()];
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final title =
        (data['title'] ?? data['text'] ?? 'PrimeX Listing').toString();
    final price = (data['price'] ?? '').toString();
    final details = (data['details'] ?? data['description'] ?? '').toString();
    final location = [
      data['city'],
      data['state'],
    ].where((e) => e != null && e.toString().trim().isNotEmpty).join(', ');

    final photos = [
      ...mediaList(data['photos']),
      ...mediaList(data['photoUrls']),
      ...mediaList(data['images']),
      ...mediaList(data['imageUrls']),
      ...mediaList(data['mediaUrls']),
    ];

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF101827),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.cyanAccent.withOpacity(.35)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (photos.isNotEmpty)
              SizedBox(
                height: 135,
                child: PageView(
                  children: photos.take(5).map((url) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        color: Colors.black,
                        child: Image.network(
                          url,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Icon(Icons.image_not_supported,
                                color: Colors.white54),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 10),
            Text(title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            if (price.isNotEmpty)
              Text('\$$price',
                  style: const TextStyle(
                      color: Colors.amberAccent, fontWeight: FontWeight.bold)),
            if (location.isNotEmpty)
              Text(location,
                  style:
                      const TextStyle(color: Colors.cyanAccent, fontSize: 12)),
            if (details.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(details,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 13)),
              ),
            if (data['isBoosted'] == true || data['boostRank'] == 999999)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('BOOSTED • Top Placement',
                    style: TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
              ),
          ],
        ),
      ),
    );
  }
}
