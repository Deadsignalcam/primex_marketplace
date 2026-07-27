import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrimeXMarketCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onTap;
  final VoidCallback? onMessage;

  const PrimeXMarketCard({
    super.key,
    required this.data,
    this.onTap,
    this.onMessage,
  });

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

  @override
  Widget build(BuildContext context) {
    final title =
        (data['title'] ?? data['text'] ?? data['caption'] ?? 'PrimeX Item')
            .toString();
    final price = (data['price'] ?? '').toString();
    final details = (data['details'] ?? data['description'] ?? '').toString();
    final city = (data['city'] ?? '').toString();
    final state = (data['state'] ?? '').toString();

    final photos = [
      ...media(data['photoUrls']),
      ...media(data['imageUrls']),
      ...media(data['photos']),
      ...media(data['images']),
      ...media(data['mediaUrls']),
    ];

    final photo = photos.isNotEmpty ? photos.first : '';

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF061125).withOpacity(.88),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF00E5FF).withOpacity(.55)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64,
              height: 64,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: photo.startsWith('http')
                  ? Image.network(
                      photo,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.image_not_supported,
                          color: Colors.white38),
                    )
                  : const Icon(Icons.storefront, color: Color(0xFF00E5FF)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                            color: Colors.amberAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                  if (city.isNotEmpty || state.isNotEmpty)
                    Text('$city ${state.isNotEmpty ? state : ''}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.cyanAccent, fontSize: 11)),
                  if (details.isNotEmpty)
                    Text(details,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: onMessage,
                        icon: const Icon(Icons.message, size: 14),
                        label: const Text('Message',
                            style: TextStyle(fontSize: 12)),
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          await Clipboard.setData(
                            ClipboardData(text: 'PrimeX Marketplace: $title'),
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Copied. Ready to share.')),
                            );
                          }
                        },
                        icon: const Icon(Icons.share, size: 14),
                        label:
                            const Text('Share', style: TextStyle(fontSize: 12)),
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
}
