import 'package:flutter/material.dart';

class PrimeXFullPhotoViewer extends StatefulWidget {
  const PrimeXFullPhotoViewer({
    super.key,
    required this.photos,
    required this.startIndex,
  });

  final List<String> photos;
  final int startIndex;

  @override
  State<PrimeXFullPhotoViewer> createState() => _PrimeXFullPhotoViewerState();
}

class _PrimeXFullPhotoViewerState extends State<PrimeXFullPhotoViewer> {
  late final PageController controller;
  late int index;

  @override
  void initState() {
    super.initState();
    index = widget.startIndex;
    controller = PageController(initialPage: widget.startIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('${index + 1} of ${widget.photos.length}'),
      ),
      body: PageView.builder(
        controller: controller,
        itemCount: widget.photos.length,
        onPageChanged: (i) => setState(() => index = i),
        itemBuilder: (_, i) => InteractiveViewer(
          minScale: 1,
          maxScale: 5,
          child: Center(
            child: Image.network(
              widget.photos[i],
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.broken_image,
                color: Colors.redAccent,
                size: 90,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
