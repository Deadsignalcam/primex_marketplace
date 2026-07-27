#!/usr/bin/env bash
set -e

cp lib/main.dart "lib/main_backup_before_map_only_$(date +%Y%m%d_%H%M%S).dart"

flutter pub add google_maps_flutter
flutter pub get

grep -q "google_maps_flutter" lib/main.dart || sed -i "1i import 'package:google_maps_flutter/google_maps_flutter.dart';" lib/main.dart

START=$(grep -n "Widget mapPage" lib/main.dart | head -1 | cut -d: -f1)
END=$(grep -n "Widget postListing" lib/main.dart | head -1 | cut -d: -f1)

if [ -z "$START" ] || [ -z "$END" ]; then
echo "Could not find mapPage or postListing."
exit 1
fi

head -n $((START-1)) lib/main.dart > /tmp/primex_new_main.dart

cat >> /tmp/primex_new_main.dart <<'DART'
Widget mapPage() => pageBox(
'PrimeX Live Google Map',
'Real Google Map wired with PrimeX pins. Foreclosure and tax sale details stay locked for PrimeX Pro.',
[
SizedBox(
height: 560,
child: ClipRRect(
borderRadius: BorderRadius.circular(18),
child: GoogleMap(
initialCameraPosition: const CameraPosition(
target: LatLng(40.3267, -78.9219),
zoom: 8,
),
mapType: MapType.normal,
zoomControlsEnabled: true,
myLocationButtonEnabled: true,
markers: {
const Marker(
markerId: MarkerId('real_estate_johnstown'),
position: LatLng(40.3267, -78.9219),
infoWindow: InfoWindow(
title: 'Real Estate',
snippet: 'Single Family Home • Johnstown, PA • 89,900 dollars',
),
),
const Marker(
markerId: MarkerId('vehicle_pittsburgh'),
position: LatLng(40.4406, -79.9959),
infoWindow: InfoWindow(
title: 'Vehicle',
snippet: 'Used Car • Pittsburgh, PA • 15,900 dollars',
),
),
const Marker(
markerId: MarkerId('tools_altoona'),
position: LatLng(40.5187, -78.3947),
infoWindow: InfoWindow(
title: 'Tools',
snippet: 'Power Tools • Altoona, PA • 199 dollars',
),
),
const Marker(
markerId: MarkerId('service_cambria'),
position: LatLng(40.4595, -78.5917),
infoWindow: InfoWindow(
title: 'Service',
snippet: 'Property Field Inspector • Cambria County, PA',
),
),
Marker(
markerId: const MarkerId('foreclosure_locked'),
position: const LatLng(40.4851, -78.7247),
infoWindow: InfoWindow(
title: primeXPro ? 'Foreclosure Lead' : 'Locked Foreclosure Lead',
snippet: primeXPro
? 'Cambria County, PA • PrimeX Pro Active'
: 'PrimeX Pro required • 49.99 per month',
),
),
Marker(
markerId: const MarkerId('tax_sale_locked'),
position: const LatLng(41.0589, -75.3396),
infoWindow: InfoWindow(
title: primeXPro ? 'Tax Sale Lead' : 'Locked Tax Sale Lead',
snippet: primeXPro
? 'Monroe County, PA • PrimeX Pro Active'
: 'PrimeX Pro required • 49.99 per month',
),
),
},
),
),
),
const SizedBox(height: 16),
card('📍', 'Public Pins', 'Real estate, vehicles, tools, services, jobs, rentals, and regular marketplace listings are visible.'),
card('🔒', 'PrimeX Pro Pins', 'Foreclosures and tax sale lead details unlock only after PrimeX Pro is active.'),
if (!primeXPro)
fullBtn('Unlock PrimeX Pro 49.99 per month', () => setState(() => primeXPro = true)),
],
);

DART

tail -n +$END lib/main.dart >> /tmp/primex_new_main.dart
mv /tmp/primex_new_main.dart lib/main.dart

echo "Checking real map widget..."
grep -n "GoogleMap(" lib/main.dart

flutter clean
flutter pub get
flutter run -d chrome
