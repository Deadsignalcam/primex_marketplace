import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LiveMapPanel extends StatelessWidget {
  const LiveMapPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('listings').snapshots(),
      builder: (context, snapshot) {
        final docs = snapshot.data?.docs ?? [];

        final markers = docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final lat = (data['lat'] ?? 40.3267).toDouble();
          final lng = (data['lng'] ?? -78.9219).toDouble();

          return Marker(
            point: LatLng(lat, lng),
            width: 60,
            height: 60,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: Colors.black,
                    title: Text(
                      data['title'] ?? 'PrimeX Listing',
                      style: const TextStyle(color: Colors.white),
                    ),
                    content: Text(
                      '${data['category'] ?? ''}\n${data['description'] ?? ''}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                );
              },
              child: const Icon(
                Icons.location_pin,
                color: Colors.redAccent,
                size: 42,
              ),
            ),
          );
        }).toList();

        return FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(40.3267, -78.9219),
            initialZoom: 11,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.primex.marketplace',
            ),
            MarkerLayer(markers: markers),
          ],
        );
      },
    );
  }
}
