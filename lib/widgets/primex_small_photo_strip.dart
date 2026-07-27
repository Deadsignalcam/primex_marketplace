import 'package:flutter/material.dart';

class PrimeXSmallPhotoStrip extends StatelessWidget {
  final List<String> photos;
  final double size;

  const PrimeXSmallPhotoStrip({
    super.key,
    required this.photos,
    this.size = 86,
  });

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: size,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: photos.length > 8 ? 8 : photos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          return Container(
            width: size,
            height: size,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.cyanAccent.withOpacity(.35)),
            ),
            child: Image.network(
              photos[i],
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image, color: Colors.white38),
            ),
          );
        },
      ),
    );
  }
}
