import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RealMapScreen extends StatelessWidget {
  const RealMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(40.3267, -78.9220),
        zoom: 12,
      ),
      markers: {
        const Marker(
          markerId: MarkerId('johnstown-house'),
          position: LatLng(40.3267, -78.9220),
          infoWindow: InfoWindow(
            title: 'House',
            snippet: 'Real Estate - Johnstown, PA',
          ),
        ),
      },
    );
  }
}
