import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../services/primex_sound_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/primex_video_player.dart';
import '../listings/listing_details_page.dart';

class ListingsPage extends StatefulWidget {
  final String? initialCategory;
  const ListingsPage({super.key, this.initialCategory});

  @override
  State<ListingsPage> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  final title = TextEditingController();
  final price = TextEditingController();
  final desc = TextEditingController();
  final address = TextEditingController();

  String country = 'United States';
  String state = 'Pennsylvania';
  String county = '';
  String city = '';
  String boost = 'No Boost';
  bool posting = false;

  List<PlatformFile> photos = [];
  PlatformFile? video;

  final boostLinks = {
    'No Boost': '',
    'Boost 4 Days - 7.99 dollars':
        'https://buy.stripe.com/cNi14nfcT7ve3Oj1wdgfU0k',
    'Boost 15 Days - 14.99 dollars':
        'https://buy.stripe.com/fZucN5c0n5n47ev4llpgfU0f',
    'Top Listing 35 Days - 5 dollars':
        'https://buy.stripe.com/28E8wP6GceXEgB5fm3gfu08',
  };

  InputDecoration input(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.black.withOpacity(.72),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF00E5FF)),
        ),
      );

  Future<void> pickMedia() async {
    final r = await FilePicker.platform.pickFiles(
      type: FileType.media,
      allowMultiple: true,
      withData: true,
    );
    if (r == null) return;

    final newPhotos = <PlatformFile>[];
    PlatformFile? newVideo = video;

    for (final f in r.files.where((x) => x.bytes != null)) {
      final n = f.name.toLowerCase();
      final isPhoto = n.endsWith('.jpg') ||
          n.endsWith('.jpeg') ||
          n.endsWith('.png') ||
          n.endsWith('.webp');
      final isVideo = n.endsWith('.mp4') ||
          n.endsWith('.mov') ||
          n.endsWith('.webm') ||
          n.endsWith('.m4v');

      if (isPhoto) newPhotos.add(f);
      if (isVideo && newVideo == null) newVideo = f;
    }

    setState(() {
      photos = [...photos, ...newPhotos].take(25).toList();
      video = newVideo;
    });

    await PrimeXSoundService.bell();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Now selected ${photos.length} photos${video != null ? ' and 1 video' : ''}.')),
    );
  }

  Future<void> payBoost() async {
    final link = boostLinks[boost] ?? '';
    if (link.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Select a paid boost first.')));
      return;
    }
    await launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
  }

  Future<String> uploadFile(PlatformFile f) async {
    final safe = f.name.replaceAll(' ', '_');
    final ref = FirebaseStorage.instance
        .ref('listing_media/${DateTime.now().millisecondsSinceEpoch}_$safe');
    await ref.putData(f.bytes as Uint8List);
    return ref.getDownloadURL();
  }

  Future<void> publishListing() async {
    if (title.text.trim().isEmpty) return;
    setState(() => posting = true);

    final user = FirebaseAuth.instance.currentUser;
    final imageUrls = <String>[];
    String videoUrl = '';

    for (final f in photos.take(25)) {
      imageUrls.add(await uploadFile(f));
    }

    if (video != null) {
      videoUrl = await uploadFile(video!);
    }

    double lat = 40.4406;
    double lng = -79.9959;
    try {
      final fullAddress = '${address.text}, $city, $county, $state, $country';
      final places = await locationFromAddress(fullAddress);
      if (places.isNotEmpty) {
        lat = places.first.latitude;
        lng = places.first.longitude;
      }
    } catch (_) {}

    final fullAddress = [
      address.text.trim(),
      city,
      county,
      state,
      country,
    ].where((e) => e.toString().trim().isNotEmpty).join(', ');

    try {
      final results = await locationFromAddress(fullAddress);
      if (results.isNotEmpty) {
        lat = results.first.latitude;
        lng = results.first.longitude;
      }
    } catch (_) {}

    await FirebaseFirestore.instance.collection('listings').add({
      'uid': user?.uid ?? '',
      'displayName': user?.displayName ?? 'Syntax Phantom',
      'photoURL': user?.photoURL ?? '',
      'title': title.text.trim(),
      'price': price.text.trim(),
      'description': desc.text.trim(),
      'address': address.text.trim(),
      'country': country,
      'state': state,
      'county': county,
      'city': city,
      'searchLocation': '$city $county $state $country',
      'category': widget.initialCategory ?? 'General',
      'imageUrls': imageUrls,
      'videoUrl': videoUrl,
      'mediaUrl': imageUrls.isNotEmpty ? imageUrls.first : videoUrl,
      'boost': boost,
      'lat': lat,
      'lng': lng,
      'emailHidden': true,
      'phoneHidden': true,
      'safeContactOnly': true,
      'createdAt': FieldValue.serverTimestamp(),
    });

    title.clear();
    price.clear();
    desc.clear();
    address.clear();

    setState(() {
      photos.clear();
      video = null;
      boost = 'No Boost';
      posting = false;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Listing posted live.')));
  }

  Widget mediaPreview() {
    if (photos.isEmpty && video == null) {
      return const Text('No media selected. Add up to 25 photos and 1 video.',
          style: TextStyle(color: Colors.white70));
    }

    return SizedBox(
      height: 125,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...photos.asMap().entries.map((e) {
            final i = e.key;
            final f = e.value;
            return previewTile(
              child: Image.memory(f.bytes!, fit: BoxFit.cover),
              onRemove: () => setState(() => photos.removeAt(i)),
            );
          }),
          if (video != null)
            previewTile(
              child: const Icon(Icons.play_circle_fill,
                  color: Color(0xFF00E5FF), size: 48),
              onRemove: () => setState(() => video = null),
            ),
        ],
      ),
    );
  }

  Widget previewTile({required Widget child, required VoidCallback onRemove}) {
    return Container(
      width: 115,
      height: 115,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00E5FF)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(child: child),
          Positioned(
            right: 2,
            top: 2,
            child: GestureDetector(
              onTap: onRemove,
              child: const Icon(Icons.cancel, color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget listingCard(QueryDocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    final imgs = d['imageUrls'] is List ? d['imageUrls'] as List : [];
    final img = imgs.isNotEmpty
        ? imgs.first.toString()
        : (d['mediaUrl'] ?? '').toString();
    final vid = (d['videoUrl'] ?? '').toString();

    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ListingDetailsPage(data: d, listingId: doc.id))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF061125).withOpacity(.82),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF00E5FF)),
        ),
        child: Row(
          children: [
            Container(
              width: 78,
              height: 78,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(12)),
              child: img.isNotEmpty
                  ? Image.network(img, fit: BoxFit.cover)
                  : vid.isNotEmpty
                      ? PrimeXVideoPlayer(url: vid)
                      : const Icon(Icons.storefront, color: Color(0xFF00E5FF)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text((d['title'] ?? 'PrimeX Listing').toString(),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    Text((d['price'] ?? '').toString(),
                        style: const TextStyle(color: Colors.amberAccent)),
                    Text('${d['city'] ?? ''}, ${d['state'] ?? ''}',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12)),
                    const Text('Secure PrimeX contact only',
                        style:
                            TextStyle(color: Color(0xFF00E5FF), fontSize: 11)),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = const BoxDecoration(
      image: DecorationImage(
          image: AssetImage('assets/images/primex_home_bg.png'),
          fit: BoxFit.cover),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Post Listing'),
          centerTitle: true),
      body: Container(
        decoration: bg,
        child: Container(
          color: Colors.black.withOpacity(.25),
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              TextField(
                  controller: title,
                  style: const TextStyle(color: Colors.white),
                  decoration: input('Title')),
              const SizedBox(height: 8),
              TextField(
                  controller: price,
                  style: const TextStyle(color: Colors.white),
                  decoration: input('Price')),
              const SizedBox(height: 8),
              TextField(
                  controller: desc,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 3,
                  decoration: input('Description')),
              const SizedBox(height: 8),
              TextField(
                  controller: address,
                  style: const TextStyle(color: Colors.white),
                  decoration: input('Address')),
              const SizedBox(height: 8),
              TextField(
                  onChanged: (v) => city = v,
                  style: const TextStyle(color: Colors.white),
                  decoration: input('City')),
              const SizedBox(height: 8),
              TextField(
                  onChanged: (v) => county = v,
                  style: const TextStyle(color: Colors.white),
                  decoration: input('County')),
              const SizedBox(height: 8),
              TextField(
                  onChanged: (v) => state = v.isEmpty ? state : v,
                  style: const TextStyle(color: Colors.white),
                  decoration: input('State')),
              const SizedBox(height: 8),
              TextField(
                  onChanged: (v) => country = v.isEmpty ? country : v,
                  style: const TextStyle(color: Colors.white),
                  decoration: input('Country')),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: boost,
                dropdownColor: Colors.black,
                decoration: input('Boost / Promotion'),
                style: const TextStyle(color: Colors.white),
                items: boostLinks.keys
                    .map((x) => DropdownMenuItem(value: x, child: Text(x)))
                    .toList(),
                onChanged: (v) => setState(() => boost = v ?? 'No Boost'),
              ),
              const SizedBox(height: 8),
              if (boost != 'No Boost')
                ElevatedButton.icon(
                  onPressed: payBoost,
                  icon: const Icon(Icons.payment),
                  label: const Text('Pay Selected Boost With Stripe'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00E5FF),
                      foregroundColor: Colors.black),
                ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: pickMedia,
                icon: const Icon(Icons.upload_file),
                label: const Text('Upload 25 Photos + 1 Video'),
                style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF00E5FF))),
              ),
              const SizedBox(height: 8),
              mediaPreview(),
              const SizedBox(height: 12),
              const Text(
                'PrimeX protects users: no personal phone numbers or emails are shown. Buyers use secure PrimeX chat, Wi-Fi audio, and Wi-Fi video.',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: posting ? null : publishListing,
                icon: const Icon(Icons.publish),
                label: Text(posting ? 'Posting...' : 'Post Listing Live'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black),
              ),
              const SizedBox(height: 20),
              const Text('Live Listings',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('listings')
                    .orderBy('createdAt', descending: true)
                    .limit(30)
                    .snapshots(),
                builder: (context, snap) {
                  if (snap.hasError)
                    return Text('Listings error: ${snap.error}',
                        style: const TextStyle(color: Colors.redAccent));
                  if (!snap.hasData)
                    return const Text('Loading listings...',
                        style: TextStyle(color: Colors.white70));
                  return Column(
                      children: snap.data!.docs.map(listingCard).toList());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
