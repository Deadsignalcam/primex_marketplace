import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/primex_contact_action_bar.dart';
import '../profile/primex_public_profile_page.dart';

Future<void> sharePrimeXListing(
    BuildContext context, Map<String, dynamic> data) async {
  final title = (data['title'] ?? 'PrimeX Listing').toString();
  final price = (data['price'] ?? '').toString();
  final city = (data['city'] ?? '').toString();
  final state = (data['state'] ?? '').toString();

  await Clipboard.setData(
    ClipboardData(text: 'PrimeX Marketplace: $title $price $city $state'),
  );

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Listing copied. Ready to share.')),
    );
  }
}

class MapPinDetailPage extends StatelessWidget {
  const MapPinDetailPage({super.key, required this.data});

  final Map<String, dynamic> data;

  List<String> allPhotos() {
    final out = <String>[];

    void add(dynamic v) {
      if (v is String && v.startsWith('http')) out.add(v);
      if (v is List) {
        for (final x in v) {
          if (x is String && x.startsWith('http')) out.add(x);
        }
      }
    }

    add(data['photoUrls']);
    add(data['imageUrls']);
    add(data['photos']);
    add(data['images']);
    add(data['mediaUrls']);
    add(data['bannerUrls']);
    add(data['thumbnail']);
    add(data['imageUrl']);

    return out.toSet().take(25).toList();
  }

  void openGallery(BuildContext context, List<String> photos, int start) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(.95),
      builder: (_) {
        final controller = PageController(initialPage: start);
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: const EdgeInsets.all(6),
          child: Stack(
            children: [
              PageView.builder(
                controller: controller,
                itemCount: photos.length,
                itemBuilder: (_, index) {
                  return InteractiveViewer(
                    minScale: .8,
                    maxScale: 4,
                    child: Center(
                      child: Image.network(
                        photos[index],
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.broken_image,
                          color: Colors.white,
                          size: 70,
                        ),
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white, size: 34),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> shareListing() async {
    final title = (data['title'] ?? 'PrimeX Listing').toString();
    final url = Uri.encodeComponent('https://primexmarketplace.com');
    await launchUrl(Uri.parse('mailto:?subject=$title&body=$url'));
  }

  @override
  Widget build(BuildContext context) {
    final photos = allPhotos();

    final uid =
        (data['uid'] ?? data['ownerUid'] ?? data['sellerUid'] ?? '').toString();
    final avatar =
        (data['photoUrl'] ?? data['profilePhoto'] ?? data['sellerPhoto'] ?? '')
            .toString();
    final name = (data['displayName'] ??
            data['sellerName'] ??
            data['ownerName'] ??
            'Syntax Phantom')
        .toString();

    final title =
        (data['title'] ?? data['text'] ?? 'PrimeX Listing').toString();
    final price = (data['price'] ?? data['currentBid'] ?? '').toString();
    final details = (data['details'] ??
            data['description'] ??
            data['listingDetails'] ??
            data['text'] ??
            '')
        .toString();
    final address = (data['address'] ?? data['location'] ?? '').toString();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('PrimeX Listing'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          if (photos.isNotEmpty)
            InkWell(
              onTap: () => openGallery(context, photos, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  photos.first,
                  height: 82,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            )
          else
            Container(
              height: 82,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.cyanAccent),
              ),
              child:
                  const Icon(Icons.image, color: Colors.cyanAccent, size: 60),
            ),
          const SizedBox(height: 10),
          if (photos.length > 1)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: photos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
              ),
              itemBuilder: (_, i) {
                return InkWell(
                  onTap: () => openGallery(context, photos, i),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(photos[i], fit: BoxFit.contain),
                  ),
                );
              },
            ),
          const SizedBox(height: 14),
          InkWell(
            onTap: uid.isEmpty
                ? null
                : () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PrimeXPublicProfilePage(uid: uid, profile: data),
                      ),
                    ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.cyanAccent,
                  backgroundImage:
                      avatar.startsWith('http') ? NetworkImage(avatar) : null,
                  child: avatar.startsWith('http')
                      ? null
                      : const Icon(Icons.person, color: Colors.black),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.cyanAccent),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
          ),
          if (price.isNotEmpty)
            Text(
              '\$$price',
              style: const TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 22,
                  fontWeight: FontWeight.w900),
            ),
          if (address.isNotEmpty)
            Text(address, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          PrimeXContactActionBar(data: data),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: shareListing,
            icon: const Icon(Icons.share),
            label: const Text('Share Listing'),
          ),
          const SizedBox(height: 12),
          Text(
            details,
            style: const TextStyle(
                color: Colors.white, fontSize: 15, height: 1.35),
          ),
        ],
      ),
    );
  }
}
