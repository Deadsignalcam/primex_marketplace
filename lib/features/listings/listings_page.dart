import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../services/primex_location_service.dart';
import 'edit_listing_page.dart';
import '../../widgets/primex_boost_buttons.dart';

class ListingsPage extends StatefulWidget {
  final String initialCategory;

  const ListingsPage({
    super.key,
    this.initialCategory = 'General',
  });

  @override
  State<ListingsPage> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  final title = TextEditingController();
  final price = TextEditingController();
  final details = TextEditingController();
  final address = TextEditingController();
  final city = TextEditingController();
  final county = TextEditingController();
  final state = TextEditingController();
  final country = TextEditingController(text: 'USA');
  final zip = TextEditingController();

  final photos = <PlatformFile>[];
  PlatformFile? video;
  bool saving = false;
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory;
  }

  InputDecoration deco(String label, IconData icon) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.cyanAccent),
        filled: true,
        fillColor: const Color(0xFF07111F),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      );

  Future<void> pickPhotos() async {
    final r = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: true, withData: true);
    if (r == null) return;
    setState(() {
      photos.clear();
      photos.addAll(r.files.take(25));
    });
  }

  Future<void> pickVideo() async {
    final r = await FilePicker.platform
        .pickFiles(type: FileType.video, allowMultiple: false, withData: true);
    if (r == null || r.files.isEmpty) return;
    setState(() => video = r.files.first);
  }

  Future<String?> uploadFile(
      String listingId, PlatformFile f, String folder) async {
    if (f.bytes == null) return null;
    final cleanName = f.name.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    final ref = FirebaseStorage.instance.ref(
        'listings/$listingId/$folder/${DateTime.now().millisecondsSinceEpoch}_$cleanName');
    await ref.putData(f.bytes!);
    return ref.getDownloadURL();
  }

  Future<void> saveListing() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (title.text.trim().isEmpty ||
        city.text.trim().isEmpty ||
        state.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Add title, city, and state.')));
      return;
    }

    setState(() => saving = true);

    final listingRef = FirebaseFirestore.instance.collection('listings').doc();
    final listingId = listingRef.id;

    final fullAddress = [
      city.text.trim(),
      state.text.trim(),
      country.text.trim(),
    ].where((x) => x.isNotEmpty).join(', ');

    double? lat;
    double? lng;

    final pin = await PrimeXLocationService.fromPostArea(
      city: city.text.trim(),
      state: state.text.trim(),
      country: country.text.trim().isEmpty ? 'USA' : country.text.trim(),
    );

    if (pin == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Could not map this Post City/State. Check City, State, Country.')),
        );
        setState(() => saving = false);
      }
      return;
    }

    lat = pin.lat;
    lng = pin.lng;

    final photoUrls = <String>[];
    for (final f in photos.take(25)) {
      final url = await uploadFile(listingId, f, 'photos');
      if (url != null) photoUrls.add(url);
    }

    String videoUrl = '';
    if (video != null) {
      videoUrl = await uploadFile(listingId, video!, 'video') ?? '';
    }

    final profile = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final p = profile.data() ?? {};

    await listingRef.set({
      'id': listingId,
      'title': title.text.trim(),
      'price': price.text.trim(),
      'details': details.text.trim(),
      'category': selectedCategory,
      'listingCategory': selectedCategory,
      'address': address.text.trim(),
      'city': city.text.trim(),
      'county': county.text.trim(),
      'state': state.text.trim(),
      'country': country.text.trim(),
      'zip': zip.text.trim(),
      'postAddress': address.text.trim(),
      'postCity': city.text.trim(),
      'postCounty': county.text.trim(),
      'postState': state.text.trim(),
      'postCountry': country.text.trim(),
      'postZip': zip.text.trim(),
      'postAreaEnabled': true,
      'locationSource': 'craigslist_post_area',
      'mapLocationSource': 'craigslist_post_area',
      'mapLocationSource': 'craigslist_post_area',
      'pinCity': city.text.trim(),
      'pinState': state.text.trim(),
      'pinCountry': country.text.trim(),
      'lat': lat,
      'lng': lng,
      'latitude': lat,
      'longitude': lng,
      'photoUrls': photoUrls,
      'photos': photoUrls,
      'videoUrl': videoUrl,
      'videoUrls': videoUrl.isEmpty ? [] : [videoUrl],
      'ownerUid': user.uid,
      'userId': user.uid,
      'uid': user.uid,
      'ownerName':
          (p['displayName'] ?? p['name'] ?? user.email ?? 'PrimeX Member')
              .toString(),
      'ownerPhoto': (p['photoUrl'] ?? p['profilePhoto'] ?? p['avatarUrl'] ?? '')
          .toString(),
      'boostEligible': true,
      'boosted': false,
      'boostStatus': 'not_boosted',
      'boostPlan': '',
      'boostPriority': 0,
      'boostExpiresAt': null,
      'status': 'active',
      'active': true,
      'isActive': true,
      'approved': true,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    title.clear();
    price.clear();
    details.clear();
    address.clear();
    city.clear();
    county.clear();
    state.clear();
    zip.clear();
    photos.clear();
    video = null;

    if (!mounted) return;
    setState(() => saving = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Listing posted, saved to profile, and pinned on map.')));
  }

  Widget field(TextEditingController c, String label, IconData icon,
          {int lines = 1}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextField(
            controller: c,
            maxLines: lines,
            style: const TextStyle(color: Colors.white),
            decoration: deco(label, icon)),
      );

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black, title: const Text('Post Listing')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Text('Posting Category: $selectedCategory',
              style: const TextStyle(
                  color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          field(title, 'Title', Icons.title),
          field(price, 'Price / Amount', Icons.attach_money),
          field(details, 'Details', Icons.notes, lines: 4),
          field(address, 'Property / Item Address or Area', Icons.location_on),
          field(city, 'City', Icons.location_city),
          field(county, 'County', Icons.map),
          field(state, 'State', Icons.flag),
          field(country, 'Country', Icons.public),
          field(zip, 'Zip / Postal Code', Icons.location_searching),
          OutlinedButton.icon(
            onPressed: pickPhotos,
            icon: const Icon(Icons.photo_library),
            label: Text('Add Photos (${photos.length}/25)'),
          ),
          OutlinedButton.icon(
            onPressed: pickVideo,
            icon: const Icon(Icons.video_library),
            label: Text(video == null ? 'Add 1 Video' : 'Video Selected'),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: saving ? null : saveListing,
            icon: const Icon(Icons.cloud_upload),
            label: Text(saving ? 'POSTING...' : 'POST LISTING'),
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                backgroundColor: const Color(0xFF00E5FF),
                foregroundColor: Colors.black),
          ),
          const SizedBox(height: 16),
          const Text(
            'Boost Your Listing',
            style: TextStyle(
                color: Colors.cyanAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Post your listing first. Then select its Boost plan under My Listings.',
            style: TextStyle(color: Colors.white60),
          ),
          const SizedBox(height: 20),
          const Text('My Listings',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('listings')
                .where('userId', isEqualTo: uid)
                .snapshots(),
            builder: (context, snap) {
              final docs = snap.data?.docs ?? [];
              if (docs.isEmpty)
                return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('No listings yet.',
                        style: TextStyle(color: Colors.white70)));
              return Column(
                children: docs.map((doc) {
                  final d = doc.data() as Map<String, dynamic>;
                  final imgs =
                      List<String>.from(d['photoUrls'] ?? d['photos'] ?? []);
                  return Card(
                    color: const Color(0xFF07111F),
                    child: ListTile(
                      leading: imgs.isNotEmpty
                          ? Image.network(imgs.first,
                              width: 54, height: 54, fit: BoxFit.cover)
                          : const Icon(Icons.store, color: Colors.cyanAccent),
                      title: Text((d['title'] ?? 'Listing').toString(),
                          style: const TextStyle(color: Colors.white)),
                      subtitle: Text(
                          '${d['postCity'] ?? d['city'] ?? ''}, ${d['postState'] ?? d['state'] ?? ''}',
                          style: const TextStyle(color: Colors.white60)),
                      trailing: Wrap(
                        spacing: 6,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        EditListingPage(listingId: doc.id))),
                            icon: const Icon(Icons.edit, size: 22),
                            label: const Text('Edit',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(105, 48),
                                backgroundColor: const Color(0xFF00E5FF),
                                foregroundColor: Colors.black),
                          ),
                          PrimeXBoostButtons(
                            listingId: doc.id,
                            listingTitle:
                                (d['title'] ?? 'PrimeX Listing').toString(),
                            compact: true,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
