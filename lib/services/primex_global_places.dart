class PrimeXGlobalPlace {
  final String label;
  final String type;
  final double lat;
  final double lng;

  const PrimeXGlobalPlace({
    required this.label,
    required this.type,
    required this.lat,
    required this.lng,
  });
}

class PrimeXGlobalPlaces {
  static const usStates = [
    'Alabama',
    'Alaska',
    'Arizona',
    'Arkansas',
    'California',
    'Colorado',
    'Connecticut',
    'Delaware',
    'Florida',
    'Georgia',
    'Hawaii',
    'Idaho',
    'Illinois',
    'Indiana',
    'Iowa',
    'Kansas',
    'Kentucky',
    'Louisiana',
    'Maine',
    'Maryland',
    'Massachusetts',
    'Michigan',
    'Minnesota',
    'Mississippi',
    'Missouri',
    'Montana',
    'Nebraska',
    'Nevada',
    'New Hampshire',
    'New Jersey',
    'New Mexico',
    'New York',
    'North Carolina',
    'North Dakota',
    'Ohio',
    'Oklahoma',
    'Oregon',
    'Pennsylvania',
    'Rhode Island',
    'South Carolina',
    'South Dakota',
    'Tennessee',
    'Texas',
    'Utah',
    'Vermont',
    'Virginia',
    'Washington',
    'West Virginia',
    'Wisconsin',
    'Wyoming',
  ];

  static const countries = [
    'United States',
    'Canada',
    'Mexico',
    'United Kingdom',
    'Dominican Republic',
    'Puerto Rico',
    'Colombia',
    'Brazil',
    'Spain',
    'France',
    'Germany',
    'Italy',
    'Portugal',
    'Nigeria',
    'Ghana',
    'South Africa',
    'India',
    'China',
    'Japan',
    'Philippines',
    'Australia',
    'New Zealand',
  ];

  static const places = <PrimeXGlobalPlace>[
    PrimeXGlobalPlace(
        label: 'United States', type: 'Country', lat: 39.8283, lng: -98.5795),
    PrimeXGlobalPlace(
        label: 'Pennsylvania', type: 'State', lat: 41.2033, lng: -77.1945),
    PrimeXGlobalPlace(
        label: 'New Jersey', type: 'State', lat: 40.0583, lng: -74.4057),
    PrimeXGlobalPlace(
        label: 'New York', type: 'State', lat: 43.2994, lng: -74.2179),
    PrimeXGlobalPlace(
        label: 'Florida', type: 'State', lat: 27.6648, lng: -81.5158),
    PrimeXGlobalPlace(
        label: 'Texas', type: 'State', lat: 31.9686, lng: -99.9018),
    PrimeXGlobalPlace(
        label: 'California', type: 'State', lat: 36.7783, lng: -119.4179),
    PrimeXGlobalPlace(
        label: 'Johnstown, Cambria County, PA',
        type: 'City / County',
        lat: 40.3267,
        lng: -78.9220),
    PrimeXGlobalPlace(
        label: 'Altoona, Blair County, PA',
        type: 'City / County',
        lat: 40.5187,
        lng: -78.3947),
    PrimeXGlobalPlace(
        label: 'Pittsburgh, Allegheny County, PA',
        type: 'City / County',
        lat: 40.4406,
        lng: -79.9959),
    PrimeXGlobalPlace(
        label: 'Philadelphia, Philadelphia County, PA',
        type: 'City / County',
        lat: 39.9526,
        lng: -75.1652),
    PrimeXGlobalPlace(
        label: 'New York City, NY', type: 'City', lat: 40.7128, lng: -74.0060),
    PrimeXGlobalPlace(
        label: 'Newark, Essex County, NJ',
        type: 'City / County',
        lat: 40.7357,
        lng: -74.1724),
    PrimeXGlobalPlace(
        label: 'Miami, Miami-Dade County, FL',
        type: 'City / County',
        lat: 25.7617,
        lng: -80.1918),
    PrimeXGlobalPlace(
        label: 'Orlando, Orange County, FL',
        type: 'City / County',
        lat: 28.5383,
        lng: -81.3792),
    PrimeXGlobalPlace(
        label: 'Dallas, Dallas County, TX',
        type: 'City / County',
        lat: 32.7767,
        lng: -96.7970),
    PrimeXGlobalPlace(
        label: 'Houston, Harris County, TX',
        type: 'City / County',
        lat: 29.7604,
        lng: -95.3698),
    PrimeXGlobalPlace(
        label: 'Los Angeles, Los Angeles County, CA',
        type: 'City / County',
        lat: 34.0522,
        lng: -118.2437),
    PrimeXGlobalPlace(
        label: 'London, United Kingdom',
        type: 'Global City',
        lat: 51.5072,
        lng: -0.1276),
    PrimeXGlobalPlace(
        label: 'Toronto, Canada',
        type: 'Global City',
        lat: 43.6532,
        lng: -79.3832),
    PrimeXGlobalPlace(
        label: 'Santo Domingo, Dominican Republic',
        type: 'Global City',
        lat: 18.4861,
        lng: -69.9312),
  ];

  static List<PrimeXGlobalPlace> search(String q) {
    final text = q.trim().toLowerCase();
    if (text.isEmpty) return places.take(8).toList();

    return places
        .where((p) {
          return p.label.toLowerCase().contains(text) ||
              p.type.toLowerCase().contains(text);
        })
        .take(12)
        .toList();
  }
}
