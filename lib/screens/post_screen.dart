import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  final Function(Map<String, dynamic>)? onPost;

  const PostScreen({super.key, this.onPost});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

const neon = Color(0xFF35F3FF);
const purple = Color(0xFFFF4DFF);
const panel = Color(0xFF091327);

class _PostScreenState extends State<PostScreen> {
  final title = TextEditingController();
  final price = TextEditingController();
  final address = TextEditingController();
  final details = TextEditingController();
  final description = TextEditingController();

  String category = 'General';
  String country = 'United States';
  String state = 'Pennsylvania';
  String county = 'Cambria County';
  String city = 'Johnstown';

  final categories = [
    'General',
    'Real Estate',
    'Vehicles',
    'Jobs',
    'Services',
    'Foreclosures',
    'Tools',
    'Realtor/Broker',
  ];

  final countries = [
    'United States',
    'Canada',
    'Mexico',
    'Puerto Rico',
    'Dominican Republic',
    'United Kingdom',
    'Spain',
    'France',
    'Germany',
    'Italy',
    'Brazil',
    'Colombia',
    'Jamaica',
    'Haiti',
    'Nigeria',
    'South Africa',
    'India',
    'Philippines',
    'Australia',
  ];

  final states = [
    'Alabama',
    'Alaska',
    'Arizona',
    'Arkansas',
    'California',
    'Colorado',
    'Connecticut',
    'Delaware',
    'Florida',
    'Georgia',
    'Hawaii',
    'Idaho',
    'Illinois',
    'Indiana',
    'Iowa',
    'Kansas',
    'Kentucky',
    'Louisiana',
    'Maine',
    'Maryland',
    'Massachusetts',
    'Michigan',
    'Minnesota',
    'Mississippi',
    'Missouri',
    'Montana',
    'Nebraska',
    'Nevada',
    'New Hampshire',
    'New Jersey',
    'New Mexico',
    'New York',
    'North Carolina',
    'North Dakota',
    'Ohio',
    'Oklahoma',
    'Oregon',
    'Pennsylvania',
    'Rhode Island',
    'South Carolina',
    'South Dakota',
    'Tennessee',
    'Texas',
    'Utah',
    'Vermont',
    'Virginia',
    'Washington',
    'West Virginia',
    'Wisconsin',
    'Wyoming'
  ];

  List<String> get counties => [
        'All Counties / Areas',
        '$state County',
        '$state Metro Area',
        '$state North Area',
        '$state South Area',
      ];

  List<String> get cities => [
        'All Cities',
        'Johnstown',
        'Bushkill',
        'East Stroudsburg',
        'Philadelphia',
        'Miami',
        'Orlando',
        'New York City',
        'Los Angeles',
        'Houston',
        '$state City Center',
      ];

  final List<Uint8List> photos = [];
  String videoName = '';

  Future<void> pickPhotos() async {
    final upload = html.FileUploadInputElement()
      ..multiple = true
      ..accept = 'image/*';
    upload.click();

    upload.onChange.listen((_) {
      final files = upload.files;
      if (files == null) return;

      for (final file in files) {
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);
        reader.onLoadEnd.listen((_) {
          setState(() {
            if (photos.length < 25) photos.add(reader.result as Uint8List);
          });
        });
      }
    });
  }

  Future<void> pickVideo() async {
    final upload = html.FileUploadInputElement()..accept = 'video/*';
    upload.click();

    upload.onChange.listen((_) {
      final file = upload.files?.first;
      if (file == null) return;
      setState(() => videoName = file.name);
    });
  }

  void publishPost() {
    widget.onPost?.call({
      'title':
          title.text.trim().isEmpty ? 'New PrimeX Listing' : title.text.trim(),
      'price': price.text.trim().isEmpty ? '0' : price.text.trim(),
      'category': category,
      'country': country,
      'state': state,
      'county': county,
      'city': city,
      'address': address.text.trim(),
      'details': details.text.trim(),
      'description': description.text.trim(),
      'photos': List<Uint8List>.from(photos),
      'videoName': videoName,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Posted To PrimeX Live Feed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Text(
          'POST SYSTEM • GLOBAL LISTING',
          style:
              TextStyle(color: neon, fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 18),
        field('Title', title),
        field('Price', price),
        drop('Category', category, categories,
            (v) => setState(() => category = v!)),
        drop('Country', country, countries, (v) {
          setState(() {
            country = v!;
            state = 'Pennsylvania';
            county = counties.first;
            city = cities.first;
          });
        }),
        drop('State / Province / Region', state, states, (v) {
          setState(() {
            state = v!;
            county = counties.first;
            city = cities.first;
          });
        }),
        drop('County / Area', county, counties,
            (v) => setState(() => county = v!)),
        drop('City', city, cities, (v) => setState(() => city = v!)),
        field('Street / Address', address),
        field('Item or Property Details', details),
        field('Description', description, lines: 5),
        Text(
          'Photos Added: ${photos.length} / 25',
          style: const TextStyle(
              color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GestureDetector(
            onTap: pickPhotos, child: box('ADD\nMULTIPLE\nPHOTOS', h: 150)),
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(photos.length, (i) {
            return Stack(
              children: [
                Container(
                  width: 130,
                  height: 115,
                  decoration: glow(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.memory(photos[i], fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: () => setState(() => photos.removeAt(i)),
                    child: const Icon(Icons.delete, color: purple),
                  ),
                ),
              ],
            );
          }),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: pickVideo,
          child: Container(
            height: 110,
            decoration: glow(color: purple),
            child: Center(
              child: Text(
                videoName.isEmpty
                    ? 'ADD 1 MIN VIDEO'
                    : 'VIDEO ADDED • $videoName',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        GestureDetector(
          onTap: publishPost,
          child: Container(
            height: 60,
            decoration: glow(color: Colors.greenAccent),
            child: const Center(
              child: Text(
                'PUBLISH LISTING',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget field(String hint, TextEditingController c, {int lines = 1}) =>
      Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: glow(),
        child: TextField(
          controller: c,
          maxLines: lines,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white70),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      );

  Widget drop(String label, String value, List<String> items,
      Function(String?) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: glow(),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: panel,
          isExpanded: true,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text('$label: $e')))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget box(String text, {double h = 120}) => Container(
        height: h,
        decoration: glow(),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: neon, fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ),
      );

  BoxDecoration glow({Color color = neon}) => BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color, width: 2.5),
        boxShadow: [BoxShadow(color: color.withOpacity(.35), blurRadius: 10)],
      );
}
