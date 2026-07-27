import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../services/primex_location_service.dart';

class EditListingPage extends StatefulWidget {
  final String listingId;
  const EditListingPage({super.key, required this.listingId});

  @override
  State<EditListingPage> createState() => _EditListingPageState();
}

class _EditListingPageState extends State<EditListingPage> {
  final title = TextEditingController();
  final price = TextEditingController();
  final details = TextEditingController();
  final address = TextEditingController();
  final city = TextEditingController();
  final county = TextEditingController();
  final state = TextEditingController();
  final country = TextEditingController();
  final zip = TextEditingController();

  final newPhotos = <PlatformFile>[];
  PlatformFile? newVideo;

  List<String> oldPhotos = [];
  String oldVideo = '';

  bool loading = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final doc = await FirebaseFirestore.instance
        .collection('listings')
        .doc(widget.listingId)
        .get();
    final d = doc.data() ?? {};

    title.text = (d['title'] ?? '').toString();
    price.text = (d['price'] ?? '').toString();
    details.text = (d['details'] ?? '').toString();
    address.text = (d['postAddress'] ?? d['address'] ?? '').toString();
    city.text = (d['pinCity'] ?? d['postCity'] ?? d['city'] ?? '').toString();
    county.text = (d['postCounty'] ?? d['county'] ?? '').toString();
    state.text =
        (d['pinState'] ?? d['postState'] ?? d['state'] ?? '').toString();
    country.text =
        (d['pinCountry'] ?? d['postCountry'] ?? d['country'] ?? 'USA')
            .toString();
    zip.text = (d['postZip'] ?? d['zip'] ?? '').toString();

    oldPhotos = List<String>.from(d['photoUrls'] ?? d['photos'] ?? []);
    oldVideo = (d['videoUrl'] ?? '').toString();

    if (mounted) setState(() => loading = false);
  }

  Future<void> pickPhotos() async {
    final r = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: true, withData: true);
    if (r == null) return;
    setState(() {
      newPhotos.clear();
      newPhotos.addAll(r.files.take(25));
    });
  }

  Future<void> pickVideo() async {
    final r = await FilePicker.platform
        .pickFiles(type: FileType.video, allowMultiple: false, withData: true);
    if (r == null || r.files.isEmpty) return;
    setState(() => newVideo = r.files.first);
  }

  Future<String?> uploadFile(PlatformFile f, String folder) async {
    if (f.bytes == null) return null;
    final clean = f.name.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    final ref = FirebaseStorage.instance.ref(
        'listings/${widget.listingId}/$folder/${DateTime.now().millisecondsSinceEpoch}_$clean');
    await ref.putData(f.bytes!);
    return ref.getDownloadURL();
  }

  Future<void> save() async {
    setState(() => saving = true);

    final mapAddress = [
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

    List<String> photoUrls = oldPhotos;
    if (newPhotos.isNotEmpty) {
      photoUrls = [];
      for (final f in newPhotos.take(25)) {
        final url = await uploadFile(f, 'photos');
        if (url != null) photoUrls.add(url);
      }
    }

    String videoUrl = oldVideo;
    if (newVideo != null) {
      videoUrl = await uploadFile(newVideo!, 'video') ?? '';
    }

    final data = {
      'title': title.text.trim(),
      'price': price.text.trim(),
      'details': details.text.trim(),
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
      'pinCity': city.text.trim(),
      'pinState': state.text.trim(),
      'pinCountry': country.text.trim(),
      'mapLocationSource': 'craigslist_post_area',
      'photoUrls': photoUrls,
      'photos': photoUrls,
      'videoUrl': videoUrl,
      'videoUrls': videoUrl.isEmpty ? [] : [videoUrl],
      'updatedAt': FieldValue.serverTimestamp(),
    };

    data['lat'] = lat;
    data['lng'] = lng;
    data['latitude'] = lat;
    data['longitude'] = lng;

    await FirebaseFirestore.instance
        .collection('listings')
        .doc(widget.listingId)
        .set(data, SetOptions(merge: true));

    if (!mounted) return;
    setState(() => saving = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Listing updated and map pin refreshed.')));
    Navigator.pop(context);
  }

  InputDecoration deco(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF07111F),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF00E5FF), width: 2),
        ),
      );

  Widget field(TextEditingController c, String label, {int lines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: c,
        maxLines: lines,
        minLines: lines,
        style: const TextStyle(color: Colors.white, fontSize: 17),
        decoration: deco(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body:
            Center(child: CircularProgressIndicator(color: Color(0xFF00E5FF))),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black, title: const Text('Edit Listing')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          field(title, 'Title'),
          field(price, 'Price / Amount'),
          field(details, 'Full Details', lines: 6),
          const Text('Property / Item Location',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          field(address, 'Property Address / Item Address'),
          const SizedBox(height: 10),
          const Text('Post This Listing In — Like Craigslist',
              style: TextStyle(
                  color: Color(0xFF00E5FF),
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          field(city, 'Post City, example: Bronx'),
          field(state, 'Post State, example: NY'),
          field(country, 'Post Country, example: USA'),
          field(county, 'County / Borough'),
          field(zip, 'Zip / Postal Code'),
          OutlinedButton.icon(
            onPressed: pickPhotos,
            icon: const Icon(Icons.photo_library),
            label: Text(newPhotos.isEmpty
                ? 'Change Photos (${oldPhotos.length}/25 current)'
                : 'New Photos Selected (${newPhotos.length}/25)'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: pickVideo,
            icon: const Icon(Icons.video_library),
            label: Text(newVideo == null
                ? (oldVideo.isEmpty ? 'Add 1 Video' : 'Change Video')
                : 'New Video Selected'),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: saving ? null : save,
            icon: const Icon(Icons.save),
            label: Text(saving ? 'Saving...' : 'SAVE CHANGES'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 58),
              backgroundColor: const Color(0xFF00E5FF),
              foregroundColor: Colors.black,
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
