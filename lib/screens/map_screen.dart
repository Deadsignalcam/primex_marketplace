import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listings = [
      {
        "title": "House For Sale",
        "price": "\$125,000",
        "point": LatLng(40.3267, -78.9219),
      },
      {
        "title": "Roofing Service",
        "price": "\$500",
        "point": LatLng(40.3367, -78.9319),
      },
      {
        "title": "Vehicle Listing",
        "price": "\$8,000",
        "point": LatLng(40.3167, -78.9119),
      },
    ];

    return Container(
      color: const Color(0xFF07122A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'GLOBAL MAP',
              style: TextStyle(
                color: Color(0xFF44E4FF),
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(40.3267, -78.9219),
                    initialZoom: 11,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.primex.marketplace',
                    ),
                    MarkerLayer(
                      markers: listings.map((listing) {
                        return Marker(
                          point: listing["point"] as LatLng,
                          width: 80,
                          height: 80,
                          child: Column(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.cyanAccent,
                                size: 40,
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(.7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  listing["title"].toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
