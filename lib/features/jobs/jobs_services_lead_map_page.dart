import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class JobsServicesLeadMapPage extends StatefulWidget {
  const JobsServicesLeadMapPage({super.key});

  @override
  State<JobsServicesLeadMapPage> createState() =>
      _JobsServicesLeadMapPageState();
}

class _JobsServicesLeadMapPageState extends State<JobsServicesLeadMapPage> {
  final search = TextEditingController();

  final leads = [
    {
      'title': 'Inspection Job',
      'type': 'job',
      'lat': 40.3267,
      'lng': -78.9219,
      'sub': 'Blue pin • Field inspection'
    },
    {
      'title': 'Roofing Service',
      'type': 'service',
      'lat': 40.4406,
      'lng': -79.9959,
      'sub': 'Green pin • Local service'
    },
    {
      'title': 'Vendor Supply',
      'type': 'vendor',
      'lat': 39.9526,
      'lng': -75.1652,
      'sub': 'Orange pin • Vendor'
    },
    {
      'title': 'Contractor Lead',
      'type': 'contractor',
      'lat': 41.2033,
      'lng': -77.1945,
      'sub': 'Purple pin • Contractor'
    },
  ];

  BitmapDescriptor pinColor(String type) {
    if (type == 'job')
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    if (type == 'service')
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    if (type == 'vendor')
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
  }

  @override
  Widget build(BuildContext context) {
    final q = search.text.toLowerCase().trim();
    final filtered = leads.where((e) {
      if (q.isEmpty) return true;
      return e.values.join(' ').toLowerCase().contains(q);
    }).toList();

    final markers = filtered.map((e) {
      return Marker(
        markerId: MarkerId(e['title'].toString()),
        position: LatLng(e['lat'] as double, e['lng'] as double),
        icon: pinColor(e['type'].toString()),
        infoWindow: InfoWindow(
            title: e['title'].toString(), snippet: e['sub'].toString()),
      );
    }).toSet();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Jobs & Services Map')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
                target: LatLng(40.4406, -79.9959), zoom: 6),
            markers: markers,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
          ),
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Column(
              children: [
                TextField(
                  controller: search,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search jobs, services, vendors...',
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon:
                        const Icon(Icons.search, color: Colors.cyanAccent),
                    filled: true,
                    fillColor: Colors.black.withOpacity(.78),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.cyanAccent),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.75),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      _Legend(color: Colors.blue, text: 'Jobs'),
                      _Legend(color: Colors.green, text: 'Services'),
                      _Legend(color: Colors.orange, text: 'Vendors'),
                      _Legend(color: Colors.purple, text: 'Contractors'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.text});
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.location_on, color: color, size: 18),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}
