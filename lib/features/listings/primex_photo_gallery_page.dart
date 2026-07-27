import 'package:flutter/material.dart';

class PrimeXPhotoGalleryPage extends StatefulWidget {
  const PrimeXPhotoGalleryPage({
    super.key,
    required this.photos,
    this.startIndex = 0,
  });

  final List<String> photos;
  final int startIndex;

  @override
  State<PrimeXPhotoGalleryPage> createState() => _PrimeXPhotoGalleryPageState();
}

class _PrimeXPhotoGalleryPageState extends State<PrimeXPhotoGalleryPage> {
  late PageController controller;
  late int index;

  @override
  void initState() {
    super.initState();
    index = widget.startIndex;
    controller = PageController(initialPage: widget.startIndex);
  }

  @override
  Widget build(BuildContext context) {
    final photos = widget.photos
        .map((e) => e.toString())
        .where((e) => e.trim().isNotEmpty && e.startsWith('http'))
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(photos.isEmpty
            ? 'Photos'
            : '${index + 1} of ${photos.length} Photos'),
      ),
      body: photos.isEmpty
          ? const Center(
              child: Text('No photos found for this listing.',
                  style: TextStyle(color: Colors.white)),
            )
          : PageView.builder(
              controller: controller,
              itemCount: photos.length,
              onPageChanged: (i) => setState(() => index = i),
              itemBuilder: (_, i) => InteractiveViewer(
                minScale: 1,
                maxScale: 5,
                child: Center(
                  child: Image.network(
                    photos[i],
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image,
                        color: Colors.redAccent, size: 90),
                  ),
                ),
              ),
            ),
    );
  }
}
