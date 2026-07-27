import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdsPromotionsPage extends StatefulWidget {
  const AdsPromotionsPage({super.key});

  @override
  State<AdsPromotionsPage> createState() => _AdsPromotionsPageState();
}

class _AdsPromotionsPageState extends State<AdsPromotionsPage> {
  final title = TextEditingController();
  final desc = TextEditingController();
  bool saving = false;

  String plan = 'Standard Ad - \$4.99 • 3 photos • 1 video';

  final List<PlatformFile> photos = [];
  final List<PlatformFile> videos = [];

  final links = const {
    'Standard Ad - \$4.99 • 3 photos • 1 video':
        'https://buy.stripe.com/aFa5kD7Kg5n4bgLehZgfu0a',
    'Business Spotlight - \$9.99 • 6 photos • 1 video':
        'https://buy.stripe.com/cNi8wPggM4j05WrehZgfu0j',
    'Homepage Banner - \$19.99 • 10 photos • 2 videos':
        'https://buy.stripe.com/9B66oHaWseXE84zddVgfu0l',
  };

  int get maxPhotos {
    if (plan.contains('Business')) return 6;
    if (plan.contains('Homepage')) return 10;
    return 3;
  }

  int get maxVideos {
    if (plan.contains('Homepage')) return 2;
    return 1;
  }

  double get fee {
    if (plan.contains('9.99')) return 9.99;
    if (plan.contains('19.99')) return 19.99;
    return 4.99;
  }

  bool isImage(String e) => ['jpg', 'jpeg', 'png', 'webp'].contains(e);
  bool isVideo(String e) => ['mp4', 'mov', 'm4v', 'webm'].contains(e);

  Future<void> pay() async {
    final url = links[plan] ?? '';
    if (url.isEmpty) return;
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  Future<void> pickMedia() async {
    final r = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
        'webp',
        'mp4',
        'mov',
        'm4v',
        'webm'
      ],
    );

    if (r == null) return;

    for (final f in r.files) {
      final ext = (f.extension ?? '').toLowerCase();
      if (f.bytes == null) continue;

      if (isImage(ext) && photos.length < maxPhotos) photos.add(f);
      if (isVideo(ext) && videos.length < maxVideos) videos.add(f);
    }

    setState(() {});
  }

  Future<String> upload(String id, PlatformFile f, String folder) async {
    final safe = f.name.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    final ref =
        FirebaseStorage.instance.ref('ads_promotions/$id/$folder/$safe');
    await ref.putData(f.bytes!);
    return await ref.getDownloadURL();
  }

  Future<void> submit() async {
    final u = FirebaseAuth.instance.currentUser;
    if (u == null) return;

    if (title.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add a title before publishing.')),
      );
      return;
    }

    setState(() => saving = true);

    try {
      final ref = FirebaseFirestore.instance.collection('ads_promotions').doc();

      final imageUrls = <String>[];
      for (final f in photos) {
        imageUrls.add(await upload(ref.id, f, 'photos'));
      }

      final videoUrls = <String>[];
      for (final f in videos) {
        videoUrls.add(await upload(ref.id, f, 'videos'));
      }

      final adData = {
        'uid': u.uid,
        'email': u.email ?? '',
        'title': title.text.trim(),
        'description': desc.text.trim(),
        'plan': plan,
        'fee': fee,
        'photoLimit': maxPhotos,
        'videoLimit': maxVideos,
        'imageUrls': imageUrls,
        'photoUrls': imageUrls,
        'videoUrls': videoUrls,
        'videoUrl': videoUrls.isNotEmpty ? videoUrls.first : '',
        'type': 'ad',
        'status': 'pending_admin_review',
        'paymentStatus': 'needs_payment_or_review',
        'showOnHome': true,
        'boosted': true,
        'boostRank': fee,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await ref.set(adData);

      // Show paid/review ads inside home feed + live feed box.
      await FirebaseFirestore.instance
          .collection('professional_live_feed')
          .doc(ref.id)
          .set({
        ...adData,
        'type': 'ad',
        'source': 'ads_promotions',
        'text': title.text.trim(),
        'boosted': true,
        'boostRank': fee,
      }, SetOptions(merge: true));

      await FirebaseFirestore.instance.collection('live_feed').doc(ref.id).set({
        ...adData,
        'type': 'ad',
        'source': 'ads_promotions',
        'text': title.text.trim(),
        'boosted': true,
        'boostRank': fee,
      }, SetOptions(merge: true));

      title.clear();
      desc.clear();
      photos.clear();
      videos.clear();

      if (mounted) {
        setState(() => saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Ad submitted for review. Pay if not paid yet.')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ad failed: $e')),
        );
      }
    }
  }

  InputDecoration input(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.black.withOpacity(.65),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.cyanAccent),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black, title: const Text('Ads & Promotions')),
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset('assets/images/primex_jobs_bg.png',
                  fit: BoxFit.cover)),
          Positioned.fill(
              child: Container(color: Colors.black.withOpacity(.74))),
          ListView(
            padding: const EdgeInsets.all(14),
            children: [
              const Text(
                'PrimeX Ads & Promotions',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 26,
                    fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: plan,
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                decoration: input('Plan / Fee / Media Limit'),
                items: links.keys
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    plan = v ?? plan;
                    photos.clear();
                    videos.clear();
                  });
                },
              ),
              const SizedBox(height: 12),
              TextField(
                  controller: title,
                  style: const TextStyle(color: Colors.white),
                  decoration: input('Ad / Banner Title')),
              const SizedBox(height: 12),
              TextField(
                  controller: desc,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: input('Description')),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: pickMedia,
                icon: const Icon(Icons.upload_file),
                label: Text(
                    'Upload Media: ${photos.length}/$maxPhotos photos • ${videos.length}/$maxVideos videos'),
              ),
              if (photos.isNotEmpty || videos.isNotEmpty)
                SizedBox(
                  height: 94,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (final f in photos)
                        Container(
                          width: 94,
                          height: 94,
                          margin: const EdgeInsets.only(right: 8),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.cyanAccent),
                          ),
                          child: Image.memory(f.bytes!, fit: BoxFit.cover),
                        ),
                      for (final f in videos)
                        Container(
                          width: 118,
                          height: 94,
                          margin: const EdgeInsets.only(right: 8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.greenAccent),
                          ),
                          child: Text('VIDEO\n${f.name}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 11)),
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                onPressed: pay,
                icon: const Icon(Icons.payment),
                label: Text('Pay $fee with Stripe'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    foregroundColor: Colors.black),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: saving ? null : submit,
                icon: const Icon(Icons.publish),
                label: Text(saving ? 'Publishing...' : 'Publish / Submit Ad'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
