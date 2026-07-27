import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'map_pin_detail_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Map<String, dynamic>? selected;

  BitmapDescriptor markerFor(String type) {
    if (type == 'listing') {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    }
    if (type == 'listing_post') {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);
    }
    if (type == 'post') {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    }
    if (type == 'ad') {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
    }
    if (type == 'job') {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
    }
    return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
  }

  Future<List<Map<String, dynamic>>> loadItems() async {
    final out = <Map<String, dynamic>>[];

    Future<void> pull(String collection, String type) async {
      try {
        final snap = await FirebaseFirestore.instance
            .collection(collection)
            .limit(150)
            .get();

        for (final doc in snap.docs) {
          final d = doc.data();

          final address = (d['address'] ?? d['location'] ?? d['street'] ?? '')
              .toString()
              .trim();
          final latRaw = d['lat'];
          final lngRaw = d['lng'];

          final hasLatLng = latRaw != null && lngRaw != null;
          final hasAddress = address.isNotEmpty;

          if (!hasLatLng && !hasAddress) continue;

          d['_id'] = doc.id;
          d['_type'] = (d['pinType'] ?? type).toString();
          d['_collection'] = collection;
          d['_address'] = address;
          out.add(d);
        }
      } catch (_) {}
    }

    await pull('listings', 'listing');
    await pull('map_pins', 'listing_post');
    await pull('professional_live_feed', 'post');
    await pull('live_feed', 'post');
    await pull('ads_promotions', 'ad');
    await pull('jobs_services', 'job');

    return out;
  }

  double latOf(Map<String, dynamic> d, int i) {
    return double.tryParse((d['lat'] ?? '').toString()) ?? (40.7128 + i * .015);
  }

  double lngOf(Map<String, dynamic> d, int i) {
    return double.tryParse((d['lng'] ?? '').toString()) ??
        (-74.0060 + i * .015);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: loadItems(),
      builder: (context, snap) {
        final items = snap.data ?? [];

        final markers = <Marker>{};
        for (int i = 0; i < items.length; i++) {
          final d = items[i];
          final type = (d['_type'] ?? 'pin').toString();
          final title =
              (d['title'] ?? d['text'] ?? d['description'] ?? 'PrimeX Item')
                  .toString();
          final address =
              (d['address'] ?? d['location'] ?? d['street'] ?? '').toString();

          markers.add(
            Marker(
              markerId: MarkerId('${d['_collection']}_${d['_id']}'),
              position: LatLng(latOf(d, i), lngOf(d, i)),
              icon: markerFor(type),
              infoWindow: InfoWindow(
                title: '${type.toUpperCase()} • $title',
                snippet: address,
              ),
              onTap: () => setState(() => selected = d),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text('PrimeX Key Map • ${markers.length} Pins'),
          ),
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(40.7128, -74.0060),
                  zoom: 6,
                ),
                markers: markers,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                mapToolbarEnabled: true,
              ),
              Positioned(
                left: 10,
                right: 10,
                top: 10,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.78),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.cyanAccent),
                  ),
                  child: const Text(
                    'Green Listings • Cyan Listing Posts • Blue Posts • Gold Ads • Purple Jobs',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              if (selected != null)
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 10,
                  child: previewCard(context, selected!),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget previewCard(BuildContext context, Map<String, dynamic> d) {
    final title = (d['title'] ?? d['text'] ?? d['description'] ?? 'PrimeX Item')
        .toString();
    final address = (d['address'] ?? d['location'] ?? '').toString();
    final photos = List<String>.from(
      d['photoUrls'] ?? d['imageUrls'] ?? d['images'] ?? d['photos'] ?? [],
    );
    final photo = photos.isNotEmpty ? photos.first : '';

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MapPinDetailPage(data: d)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.86),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.cyanAccent),
        ),
        child: Row(
          children: [
            if (photo.startsWith('http'))
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(photo,
                    width: 78, height: 78, fit: BoxFit.cover),
              )
            else
              const Icon(Icons.location_pin,
                  color: Colors.cyanAccent, size: 48),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w900)),
                  Text(address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70)),
                  const Text('Tap to view full details + photos',
                      style: TextStyle(color: Colors.cyanAccent, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
