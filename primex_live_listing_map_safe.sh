#!/usr/bin/env bash
set -e

cp lib/main.dart "lib/main_backup_before_LIVE_LISTING_MAP_$(date +%Y%m%d_%H%M%S).dart"

grep -q "google_maps_flutter" lib/main.dart || sed -i "1i import 'package:google_maps_flutter/google_maps_flutter.dart';" lib/main.dart
grep -q "models/listing_model.dart" lib/main.dart || sed -i "1i import 'models/listing_model.dart';" lib/main.dart
grep -q "services/firebase_listing_service.dart" lib/main.dart || sed -i "1i import 'services/firebase_listing_service.dart';" lib/main.dart

START=$(grep -n "Widget mapPage" lib/main.dart | head -1 | cut -d: -f1)
END=$(grep -n "Widget postListing" lib/main.dart | head -1 | cut -d: -f1)

head -n $((START-1)) lib/main.dart > /tmp/primex_main_new.dart

cat >> /tmp/primex_main_new.dart <<'DART'
Widget mapPage() => pageBox(
'PrimeX Live Listing Map',
'Listings posted in Firebase now become map pins. Premium foreclosure, REO, sheriff sale, and tax sale details stay locked until PrimeX Pro is active.',
[
SizedBox(
height: 560,
child: ClipRRect(
borderRadius: BorderRadius.circular(18),
child: StreamBuilder<List<ListingModel>>(
stream: FirebaseListingService().liveListings(),
builder: (context, snapshot) {
final Set<Marker> markers = {
const Marker(
markerId: MarkerId('sample_real_estate'),
position: LatLng(40.3267, -78.9219),
infoWindow: InfoWindow(
title: 'Real Estate Sample',
snippet: 'Johnstown, PA • Firebase live pins appear here',
),
),
};

if (snapshot.hasData) {
for (final listing in snapshot.data!) {
final category = listing.category.toLowerCase();
final premium = category.contains('foreclosure') ||
category.contains('tax') ||
category.contains('reo') ||
category.contains('sheriff');

markers.add(
Marker(
markerId: MarkerId(listing.id),
position: LatLng(listing.lat, listing.lng),
infoWindow: InfoWindow(
title: premium && !isPro
? 'Locked ${listing.category}'
: '${listing.category} • ${listing.title}',
snippet: premium && !isPro
? 'PrimeX Pro required • 49.99 per month'
: '${listing.location} • ${listing.price}',
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
card('📍', 'Firebase Live Pins', 'Any listing saved with lat and lng will appear on this map.'),
card('🔒', 'PrimeX Pro Lock', 'Foreclosure, tax sale, REO, and sheriff sale lead details stay locked until PrimeX Pro is active.'),
if (!isPro)
fullBtn('Unlock PrimeX Pro 49.99 per month', () => setState(() => isPro = true)),
],
);

DART

tail -n +$END lib/main.dart >> /tmp/primex_main_new.dart
mv /tmp/primex_main_new.dart lib/main.dart

grep -n "FirebaseListingService().liveListings" lib/main.dart
grep -n "GoogleMap(" lib/main.dart

flutter clean
flutter pub get
flutter run -d chrome
