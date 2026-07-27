final Map<String, Map<String, Map<String, List<String>>>> globalLocations = {
  'Worldwide': {
    'All States / Regions': {
      'All Counties / Provinces': ['All Cities'],
    },
  },
  'United States': {
    'Pennsylvania': {
      'Cambria County': ['Johnstown', 'Ebensburg', 'Portage'],
      'Monroe County': ['East Stroudsburg', 'Stroudsburg', 'Tobyhanna'],
      'Pike County': ['Bushkill', 'Milford', 'Dingmans Ferry'],
    },
    'New York': {
      'Bronx County': ['Bronx'],
      'Kings County': ['Brooklyn'],
      'New York County': ['Manhattan'],
    },
    'Florida': {
      'Miami-Dade County': ['Miami', 'Hialeah'],
      'Orange County': ['Orlando'],
    },
  },
  'Canada': {
    'Ontario': {
      'Toronto Division': ['Toronto'],
      'Ottawa Division': ['Ottawa'],
    },
    'Quebec': {
      'Montreal Region': ['Montreal'],
      'Quebec City Region': ['Quebec City'],
    },
  },
  'United Kingdom': {
    'England': {
      'Greater London': ['London'],
      'Greater Manchester': ['Manchester'],
    },
  },
  'Dominican Republic': {
    'Santo Domingo': {
      'Distrito Nacional': ['Santo Domingo'],
    },
  },
  'Puerto Rico': {
    'Puerto Rico': {
      'San Juan Municipio': ['San Juan'],
      'Ponce Municipio': ['Ponce'],
    },
  },
};

class GlobalLocations {
  static List<String> get countries => globalLocations.keys.toList();

  static List<String> statesFor(String country) =>
      globalLocations[country]?.keys.toList() ?? ['All States / Regions'];

  static List<String> countiesFor(String country, String state) =>
      globalLocations[country]?[state]?.keys.toList() ??
      ['All Counties / Provinces'];

  static List<String> citiesFor(String country, String state, String county) =>
      globalLocations[country]?[state]?[county] ?? ['All Cities'];
}
