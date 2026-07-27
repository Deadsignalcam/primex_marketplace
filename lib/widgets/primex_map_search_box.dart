import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PrimeXMapSearchBox extends StatefulWidget {
  final GoogleMapController? controller;
  final List<Map<String, dynamic>> places;
  final void Function(Map<String, dynamic>)? onSelected;

  const PrimeXMapSearchBox({
    super.key,
    required this.controller,
    required this.places,
    this.onSelected,
  });

  @override
  State<PrimeXMapSearchBox> createState() => _PrimeXMapSearchBoxState();
}

class _PrimeXMapSearchBoxState extends State<PrimeXMapSearchBox> {
  final q = TextEditingController();

  List<Map<String, dynamic>> get results {
    final text = q.text.trim().toLowerCase();
    if (text.isEmpty) return [];
    return widget.places
        .where((p) {
          return p.values.any((v) => v.toString().toLowerCase().contains(text));
        })
        .take(8)
        .toList();
  }

  void go(Map<String, dynamic> p) {
    widget.controller?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng((p['lat'] as num).toDouble(), (p['lng'] as num).toDouble()),
        12,
      ),
    );
    widget.onSelected?.call(p);
    q.text = p['title'].toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final r = results;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.88),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00E5FF)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: q,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Search city, county, state, address...',
              hintStyle: TextStyle(color: Colors.white54),
              prefixIcon: Icon(Icons.search, color: Color(0xFF00E5FF)),
              border: InputBorder.none,
            ),
          ),
          ...r.map((p) => ListTile(
                dense: true,
                onTap: () => go(p),
                title: Text(p['title'].toString(),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text(
                    '${p['city'] ?? ''} ${p['county'] ?? ''} ${p['state'] ?? ''}',
                    style: const TextStyle(color: Colors.white70)),
                trailing: const Icon(Icons.place, color: Color(0xFF00E5FF)),
              )),
        ],
      ),
    );
  }
}
