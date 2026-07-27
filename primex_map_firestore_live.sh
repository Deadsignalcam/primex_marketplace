#!/usr/bin/env bash
set -e

cp lib/main.dart "lib/main_backup_before_FIRESTORE_MAP_$(date +%Y%m%d_%H%M%S).dart"

grep -q "cloud_firestore" lib/main.dart || sed -i "1i import 'package:cloud_firestore/cloud_firestore.dart';" lib/main.dart
grep -q "google_maps_flutter" lib/main.dart || sed -i "1i import 'package:google_maps_flutter/google_maps_flutter.dart';" lib/main.dart

START=$(grep -n "Widget mapPage" lib/main.dart | head -1 | cut -d: -f1)
END=$(grep -n "Widget postListing" lib/main.dart | head -1 | cut -d: -f1)

head -n $((START-1)) lib/main.dart > /tmp/primex_main_new.dart

cat >> /tmp/primex_main_new.dart <<'DART'
Widget mapPage() => pageBox(
'PrimeX Live Firebase Map',
'Live pins load from Firebase listings. Foreclosure and tax sale details stay locked unless PrimeX Pro is active.',
[
SizedBox(
height: 560,
child: ClipRRect(
borderRadius: BorderRadius.circular(18),
child: StreamBuilder<QuerySnapshot>(
stream: FirebaseFirestore.instance.collection('listings').snapshots(),
builder: (context, snapshot) {
final markers = <Marker>{
const Marker(
markerId: MarkerId('sample_johnstown_home'),
position: LatLng(40.3267, -78.9219),
infoWindow: InfoWindow(
title: 'Sample Real Estate',
snippet: 'Johnstown, PA • Firebase pins load here',
),
),
};

if (snapshot.hasData) {
for (final doc in snapshot.data!.docs) {
final data = doc.data() as Map<String, dynamic>;

final lat = (data['lat'] ?? data['latitude']) as num?;
final lng = (data['lng'] ?? data['longitude']) as num?;

if (lat == null || lng == null) continue;

final category = '${data['category'] ?? data['type'] ?? 'Listing'}';
final title = '${data['title'] ?? 'PrimeX Listing'}';
final city = '${data['city'] ?? data['location'] ?? ''}';
final price = '${data['price'] ?? ''}';

final premium = category.toLowerCase().contains('foreclosure') ||
category.toLowerCase().contains('tax') ||
category.toLowerCase().contains('reo') ||
category.toLowerCase().contains('sheriff');

markers.add(
Marker(
markerId: MarkerId(doc.id),
position: LatLng(lat.toDouble(), lng.toDouble()),
infoWindow: InfoWindow(
title: premium && !isPro ? 'Locked $category' : '$category • $title',
snippet: premium && !isPro
? 'PrimeX Pro required • 49.99 per month'
: '$city • $price',
),
),
);
}
}

return GoogleMap(
initialCameraPosition: const CameraPosition(
target: LatLng(40.3267, -78.9219),
zoom: 8,
),
mapType: MapType.normal,
zoomControlsEnabled: true,
myLocationButtonEnabled: true,
markers: markers,
);
},
),
),
),
const SizedBox(height: 16),
card('📍', 'Live Firebase Pins', 'Listings with lat/lng or latitude/longitude now appear on the PrimeX map.'),
card('🔒', 'PrimeX Pro Lock', 'Foreclosure, tax sale, REO, and sheriff sale details stay locked until PrimeX Pro is active.'),
if (!isPro)
fullBtn('Unlock PrimeX Pro 49.99 per month', () => setState(() => isPro = true)),
],
);

DART

tail -n +$END lib/main.dart >> /tmp/primex_main_new.dart
mv /tmp/primex_main_new.dart lib/main.dart

grep -n "FirebaseFirestore.instance.collection('listings')" lib/main.dart
grep -n "GoogleMap(" lib/main.dart

flutter clean
flutter pub get
flutter run -d chrome
