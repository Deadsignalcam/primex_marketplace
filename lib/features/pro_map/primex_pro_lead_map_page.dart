import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PrimeXProLeadMapPage extends StatefulWidget {
  const PrimeXProLeadMapPage({super.key});

  @override
  State<PrimeXProLeadMapPage> createState() => _PrimeXProLeadMapPageState();
}

class _PrimeXProLeadMapPageState extends State<PrimeXProLeadMapPage> {
  String filter = 'All';

  final leads = <Map<String, dynamic>>[
    {
      'category': 'Foreclosure',
      'title': 'Foreclosure Lead',
      'address': 'Pittsburgh, PA',
      'lat': 40.4406,
      'lng': -79.9959,
      'price': 'PrimeX Pro',
      'source': 'Foreclosure Lead Data',
      'description': 'Foreclosure opportunity lead for PrimeX Pro members.',
    },
    {
      'category': 'Tax Sale',
      'title': 'Tax Sale Property',
      'address': 'Philadelphia, PA',
      'lat': 39.9526,
      'lng': -75.1652,
      'price': 'PrimeX Pro',
      'source': 'Tax Sale Lead Data',
      'description': 'Tax sale property lead for investor review.',
    },
    {
      'category': 'Tax Lien',
      'title': 'Tax Lien Lead',
      'address': 'Scranton, PA',
      'lat': 41.4089,
      'lng': -75.6624,
      'price': 'PrimeX Pro',
      'source': 'Tax Lien Lead Data',
      'description': 'Tax lien opportunity lead for investor research.',
    },
    {
      'category': 'Sheriff Sale',
      'title': 'Sheriff Sale Lead',
      'address': 'Harrisburg, PA',
      'lat': 40.2732,
      'lng': -76.8867,
      'price': 'PrimeX Pro',
      'source': 'Sheriff Sale Lead Data',
      'description': 'Sheriff sale lead for PrimeX Pro members.',
    },
  ];

  List<String> get filters => const [
        'All',
        'Foreclosure',
        'Tax Sale',
        'Tax Lien',
        'Sheriff Sale',
      ];

  List<Map<String, dynamic>> get filtered {
    if (filter == 'All') return leads;
    return leads.where((x) => x['category'] == filter).toList();
  }

  BitmapDescriptor colorFor(String category) {
    if (category == 'Foreclosure') {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }
    if (category == 'Tax Sale') {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    }
    if (category == 'Tax Lien') {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
    }
    if (category == 'Sheriff Sale') {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
    }
    return BitmapDescriptor.defaultMarker;
  }

  Set<Marker> get markers {
    return filtered.map((d) {
      return Marker(
        markerId: MarkerId('${d['category']}-${d['title']}-${d['address']}'),
        position:
            LatLng((d['lat'] as num).toDouble(), (d['lng'] as num).toDouble()),
        icon: colorFor(d['category'].toString()),
        infoWindow: InfoWindow(
          title: d['title'].toString(),
          snippet: '${d['category']} • ${d['address']}',
        ),
        onTap: () => openLeadDetail(context, d),
      );
    }).toSet();
  }

  void openLeadDetail(BuildContext context, Map<String, dynamic> d) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF050816),
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              d['title'].toString(),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              d['category'].toString(),
              style: const TextStyle(
                  color: Color(0xFF00E5FF),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            leadLine('Address', d['address']),
            leadLine('Access', d['price']),
            leadLine('Source', d['source']),
            const SizedBox(height: 12),
            Text(
              d['description'].toString(),
              style: const TextStyle(color: Colors.white70, height: 1.35),
            ),
            const SizedBox(height: 14),
            const Text(
              'Safety guide: verify ownership, use title professionals, review county records, and never send money outside secure PrimeX-approved steps.',
              style: TextStyle(color: Colors.white54, height: 1.35),
            ),
          ],
        ),
      ),
    );
  }

  Widget leadLine(String label, dynamic value) {
    final v = (value ?? '').toString();
    if (v.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text('$label: $v', style: const TextStyle(color: Colors.white70)),
    );
  }

  Widget filterBar() {
    return Positioned(
      left: 10,
      right: 10,
      top: 10,
      child: SizedBox(
        height: 44,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: filters.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final f = filters[i];
            final active = f == filter;
            return ChoiceChip(
              selected: active,
              label: Text(f),
              selectedColor: const Color(0xFF00E5FF),
              backgroundColor: Colors.black87,
              labelStyle: TextStyle(
                  color: active ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold),
              onSelected: (_) => setState(() => filter = f),
            );
          },
        ),
      ),
    );
  }

  Widget bottomCards() {
    return Positioned(
      left: 10,
      right: 10,
      bottom: 12,
      child: SizedBox(
        height: 118,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (_, i) {
            final d = filtered[i];
            return GestureDetector(
              onTap: () => openLeadDetail(context, d),
              child: Container(
                width: 265,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.86),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF00E5FF)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(d['category'].toString(),
                        style: const TextStyle(
                            color: Color(0xFF00E5FF),
                            fontWeight: FontWeight.bold)),
                    Text(d['title'].toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(d['address'].toString(),
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12)),
                    Text(d['price'].toString(),
                        style:
                            const TextStyle(color: Colors.amber, fontSize: 12)),
                    const SizedBox(height: 4),
                    const Text('Tap for lead details',
                        style: TextStyle(color: Colors.white54, fontSize: 11)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('PrimeX Pro Lead Map'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(40.2732, -76.8867),
              zoom: 7,
            ),
            markers: markers,
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
          ),
          filterBar(),
          bottomCards(),
        ],
      ),
    );
  }
}
