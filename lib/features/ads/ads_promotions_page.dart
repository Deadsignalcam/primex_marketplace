import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const Map<String, Map<String, String>> primeXStripeProducts = {
  "standard_ad": {
    "title": "Standard Ad",
    "price": "\$4.99 / Week",
    "media": "3 photos + 1 video per week",
    "stripe": "https://buy.stripe.com/aFa5kD7Kg5n4bgLehZgfu0a",
    "photos": "3",
    "videos": "1",
  },
  "business_spotlight": {
    "title": "Business Spotlight",
    "price": "\$9.99 / Week",
    "media": "6 photos + 1 video per week",
    "stripe": "https://buy.stripe.com/cNi8wPggM4j05WrehZgfu0j",
    "photos": "10",
    "videos": "2",
  },
  "homepage_banner": {
    "title": "Homepage Banner",
    "price": "\$19.99 / Week",
    "media": "10 photos + 2 videos per week",
    "stripe": "https://buy.stripe.com/9B66oHaWseXE84zddVgfu0l",
    "photos": "15",
    "videos": "3",
  },
};

class AdsPromotionsPage extends StatefulWidget {
  const AdsPromotionsPage({super.key});

  @override
  State<AdsPromotionsPage> createState() => _AdsPromotionsPageState();
}

class _AdsPromotionsPageState extends State<AdsPromotionsPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();

  String selectedAdType = "standard_ad";
  Uint8List? mediaBytes;
  String? mediaName;
  bool loading = false;

  Map<String, String> get product => primeXStripeProducts[selectedAdType]!;

  Future<void> pickMedia() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: true,
      type: FileType.media,
    );

    if (result == null || result.files.isEmpty) return;

    setState(() {
      mediaBytes = result.files.first.bytes;
      mediaName = result.files.first.name;
    });
  }

  Future<String?> uploadMedia(String adId) async {
    if (mediaBytes == null || mediaName == null) return null;

    final ref = FirebaseStorage.instance
        .ref()
        .child("ads_promotions")
        .child(adId)
        .child(mediaName!);

    await ref.putData(mediaBytes!);
    return ref.getDownloadURL();
  }

  Future<void> saveAdThenPay() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login first.")),
      );
      return;
    }

    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Add an ad title first.")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final doc = FirebaseFirestore.instance.collection("ads_promotions").doc();
      final mediaUrl = await uploadMedia(doc.id);

      await doc.set({
        "id": doc.id,
        "userId": user.uid,
        "userEmail": user.email,
        "adType": selectedAdType,
        "adTitle": product["title"],
        "price": product["price"],
        "stripeUrl": product["stripe"],
        "title": titleController.text.trim(),
        "description": descriptionController.text.trim(),
        "link": linkController.text.trim(),
        "city": cityController.text.trim(),
        "state": stateController.text.trim(),
        "mediaUrl": mediaUrl ?? "",
        "mediaName": mediaName ?? "",
        "status": "pending_payment",
        "paymentStatus": "pending_payment",
        "showOnHome": true,
        "approved": true,
        "approved": false,
        "createdAt": FieldValue.serverTimestamp(),
      });

      await launchUrl(
        Uri.parse(product["stripe"]!),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ad payment error: $e")),
      );
    }

    if (mounted) setState(() => loading = false);
  }

  Widget adTypeButton(String key) {
    final item = primeXStripeProducts[key]!;
    final active = selectedAdType == key;

    return InkWell(
      onTap: () => setState(() => selectedAdType = key),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF062C3A) : const Color(0xFF111827),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: active ? Colors.cyanAccent : Colors.white12,
            width: active ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(height: 10),
            Container(
              key: ValueKey("AD_MEDIA_LIMIT_GUIDE"),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
              child: Text(
                "Ad Media Limits:\nStandard Ad \$4.99/week: 3 photos + 1 video\nBusiness Spotlight \$9.99/week: 6 photos + 1 video\nHomepage Banner \$19.99/week: 10 photos + 2 videos",
                style: TextStyle(
                    color: Colors.cyanAccent, fontWeight: FontWeight.bold),
              ),
            ),
            Icon(
              active ? Icons.check_circle : Icons.radio_button_unchecked,
              color: active ? Colors.cyanAccent : Colors.white54,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item["title"]!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              item["price"]!,
              style: const TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: const Color(0xFF111827),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white12),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.cyanAccent),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Ads & Promotions"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose Promotion",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            adTypeButton("standard_ad"),
            adTypeButton("business_spotlight"),
            adTypeButton("homepage_banner"),
            const SizedBox(height: 18),
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: inputStyle("Ad title"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: inputStyle("Ad description"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: linkController,
              style: const TextStyle(color: Colors.white),
              decoration: inputStyle("Website or listing link"),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: cityController,
                    style: const TextStyle(color: Colors.white),
                    decoration: inputStyle("City"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: stateController,
                    style: const TextStyle(color: Colors.white),
                    decoration: inputStyle("State"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: pickMedia,
              icon: const Icon(Icons.upload, color: Colors.cyanAccent),
              label: Text(
                mediaName == null ? "Upload image / video / clip" : mediaName!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF07111F),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.cyanAccent.withOpacity(.35)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product["title"]!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product["price"]!,
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Your ad will be saved as pending payment, then sent to Stripe. After payment, admin can approve it for homepage/live placement.",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: loading ? null : saveAdThenPay,
                icon: const Icon(Icons.payment),
                label: Text(
                  loading ? "Saving..." : "Create Ad & Pay ${product["price"]}",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
