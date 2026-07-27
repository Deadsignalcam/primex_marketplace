import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';

class PrimeXLocationResult {
  final double lat;
  final double lng;
  final String label;

  const PrimeXLocationResult(
    this.lat,
    this.lng,
    this.label,
  );
}

class PrimeXLocationService {
  static final Map<String, PrimeXLocationResult> known = {
    // NEW YORK
    'bronx,ny,usa': const PrimeXLocationResult(40.8448, -73.8648, 'Bronx, NY'),
    'new york,ny,usa':
        const PrimeXLocationResult(40.7128, -74.0060, 'New York, NY'),
    'brooklyn,ny,usa':
        const PrimeXLocationResult(40.6782, -73.9442, 'Brooklyn, NY'),
    'queens,ny,usa':
        const PrimeXLocationResult(40.7282, -73.7949, 'Queens, NY'),

    // PENNSYLVANIA
    'philadelphia,pa,usa':
        const PrimeXLocationResult(39.9526, -75.1652, 'Philadelphia, PA'),
    'pittsburgh,pa,usa':
        const PrimeXLocationResult(40.4406, -79.9959, 'Pittsburgh, PA'),
    'johnstown,pa,usa':
        const PrimeXLocationResult(40.3267, -78.9220, 'Johnstown, PA'),

    // NEW JERSEY
    'camden,nj,usa':
        const PrimeXLocationResult(39.9259, -75.1196, 'Camden, NJ'),
    'newark,nj,usa':
        const PrimeXLocationResult(40.7357, -74.1724, 'Newark, NJ'),
    'jersey city,nj,usa':
        const PrimeXLocationResult(40.7178, -74.0431, 'Jersey City, NJ'),
    'trenton,nj,usa':
        const PrimeXLocationResult(40.2171, -74.7429, 'Trenton, NJ'),
    'atlantic city,nj,usa':
        const PrimeXLocationResult(39.3643, -74.4229, 'Atlantic City, NJ'),
    'paterson,nj,usa':
        const PrimeXLocationResult(40.9168, -74.1718, 'Paterson, NJ'),
    'elizabeth,nj,usa':
        const PrimeXLocationResult(40.6639, -74.2107, 'Elizabeth, NJ'),
  };

  static String cleanText(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static String normalizeCountry(String value) {
    final country = cleanText(value).toLowerCase();

    if (country.isEmpty ||
        country == 'us' ||
        country == 'u.s.' ||
        country == 'u.s.a.' ||
        country == 'united states' ||
        country == 'united states of america') {
      return 'USA';
    }

    return cleanText(value);
  }

  static String normalizeState(String value) {
    final state = cleanText(value).toLowerCase();

    const aliases = {
      'new jersey': 'NJ',
      'nj': 'NJ',
      'pennsylvania': 'PA',
      'pa': 'PA',
      'new york': 'NY',
      'ny': 'NY',
    };

    return aliases[state] ?? cleanText(value).toUpperCase();
  }

  static String buildKey({
    required String city,
    required String state,
    required String country,
  }) {
    return [
      cleanText(city).toLowerCase(),
      normalizeState(state).toLowerCase(),
      normalizeCountry(country).toLowerCase(),
    ].join(',');
  }

  static Future<PrimeXLocationResult?> fromPostArea({
    required String city,
    required String state,
    required String country,
  }) async {
    final cleanCity = cleanText(city);
    final cleanState = normalizeState(state);
    final cleanCountry = normalizeCountry(country);

    if (cleanCity.isEmpty || cleanState.isEmpty) {
      return null;
    }

    final key = buildKey(
      city: cleanCity,
      state: cleanState,
      country: cleanCountry,
    );

    final savedLocation = known[key];

    if (savedLocation != null) {
      return savedLocation;
    }

    // The current geocoding plugin does not provide web support.
    // Known locations work immediately on PrimeX Web.
    if (kIsWeb) {
      debugPrint(
        'PrimeX Web location not found in known map: $key',
      );
      return null;
    }

    final searches = <String>[
      '$cleanCity, $cleanState, $cleanCountry',
      '$cleanCity, $cleanState',
      '$cleanCity, $cleanCountry',
    ];

    for (final search in searches) {
      try {
        final locations = await locationFromAddress(search);

        if (locations.isNotEmpty) {
          final location = locations.first;

          return PrimeXLocationResult(
            location.latitude,
            location.longitude,
            '$cleanCity, $cleanState',
          );
        }
      } catch (error) {
        debugPrint(
          'PrimeX geocoding failed for "$search": $error',
        );
      }
    }

    return null;
  }
}
