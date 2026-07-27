import 'package:flutter/material.dart';
import '../../widgets/primex_contact_action_bar.dart';

class PrimeXLeadCard extends StatelessWidget {
  final String title;
  final String type;
  final String source;
  final String thumbnail;
  final String address;
  final String description;
  final String phone;
  final VoidCallback? onMessage;

  const PrimeXLeadCard({
    super.key,
    required this.title,
    required this.type,
    required this.source,
    required this.thumbnail,
    required this.address,
    required this.description,
    required this.phone,
    this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF101827),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: thumbnail.isEmpty
                  ? Container(
                      width: 90,
                      height: 90,
                      color: Colors.black26,
                      child:
                          const Icon(Icons.work, color: Colors.cyan, size: 38),
                    )
                  : Image.network(
                      thumbnail,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text('$type • $source',
                      style: const TextStyle(color: Colors.cyanAccent)),
                  const SizedBox(height: 5),
                  Text(address, style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  Text(description,
                      style: const TextStyle(color: Colors.white60)),
                  const SizedBox(height: 10),
                  PrimeXContactActionBar(
                    data: {
                      'phone': phone,
                      'onMessage': onMessage,
                      'title': title,
                      'source': source,
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
