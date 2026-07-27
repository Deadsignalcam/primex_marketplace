#!/usr/bin/env bash
set -e

cp lib/main.dart "lib/main_backup_real_google_map_$(date +%Y%m%d_%H%M%S).dart"

flutter pub add google_maps_flutter
flutter pub get

grep -q "google_maps_flutter" lib/main.dart || sed -i "1a import 'package:google_maps_flutter/google_maps_flutter.dart';" lib/main.dart

perl -0777 -i -pe "s/Widget mapPage\(\) => pageBox\('PrimeX Map',[\\s\\S]*?\n Widget postListing/Widget mapPage() => pageBox('PrimeX Live Google Map', 'Real map is now wired. Pins show public listings. Foreclosure and tax sale pins stay locked until PrimeX Pro is active.', [\n SizedBox(\n height: 520,\n child: ClipRRect(\n borderRadius: BorderRadius.circular(18),\n child: GoogleMap(\n initialCameraPosition: const CameraPosition(\n target: LatLng(40.3267, -78.9219),\n zoom: 8,\n ),\n mapType: MapType.normal,\n myLocationButtonEnabled: true,\n zoomControlsEnabled: true,\n markers: {\n const Marker(\n markerId: MarkerId('real_estate_johnstown'),\n position: LatLng(40.3267, -78.9219),\n infoWindow: InfoWindow(title: 'Single Family Home', snippet: 'Johnstown, PA • 89,900 dollars'),\n ),\n const Marker(\n markerId: MarkerId('vehicle_pittsburgh'),\n position: LatLng(40.4406, -79.9959),\n infoWindow: InfoWindow(title: 'Used Car', snippet: 'Pittsburgh, PA • 15,900 dollars'),\n ),\n const Marker(\n markerId: MarkerId('tools_altoona'),\n position: LatLng(40.5187, -78.3947),\n infoWindow: InfoWindow(title: 'Power Tools', snippet: 'Altoona, PA • 199 dollars'),\n ),\n const Marker(\n markerId: MarkerId('service_cambria'),\n position: LatLng(40.4595, -78.5917),\n infoWindow: InfoWindow(title: 'Service Provider', snippet: 'Cambria County, PA • Deck Builder'),\n ),\n Marker(\n markerId: const MarkerId('foreclosure_locked'),\n position: const LatLng(40.4851, -78.7247),\n infoWindow: InfoWindow(\n title: primeXPro ? 'Foreclosure Lead' : 'Locked Foreclosure Lead',\n snippet: primeXPro ? 'Cambria County, PA • Pro Active' : 'PrimeX Pro required • 49.99 per month',\n ),\n ),\n Marker(\n markerId: const MarkerId('tax_sale_locked'),\n position: const LatLng(41.0589, -75.3396),\n infoWindow: InfoWindow(\n title: primeXPro ? 'Tax Sale Lead' : 'Locked Tax Sale Lead',\n snippet: primeXPro ? 'Monroe County, PA • Pro Active' : 'PrimeX Pro required • 49.99 per month',\n ),\n ),\n },\n ),\n ),\n ),\n const SizedBox(height: 16),\n card('🔵', 'Public Listing Pins', 'Real estate, vehicles, tools, jobs, services, rentals, and normal marketplace posts are visible.'),\n card('🔒', 'PrimeX Pro Locked Pins', 'Foreclosures and tax sale details unlock only after PrimeX Pro is active.'),\n if (!primeXPro) fullBtn('Unlock PrimeX Pro 49.99 per month', () => setState(() => primeXPro = true)),\n ]);\n\n Widget postListing/s" lib/main.dart

flutter clean
flutter pub get
flutter run -d chrome
