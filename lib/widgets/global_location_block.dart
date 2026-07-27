import 'package:flutter/material.dart';

const neon = Color(0xFF35F3FF);
const panel = Color(0xFF091327);

class GlobalLocationBlock extends StatefulWidget {
  const GlobalLocationBlock({super.key});

  @override
  State<GlobalLocationBlock> createState() => _GlobalLocationBlockState();
}

class _GlobalLocationBlockState extends State<GlobalLocationBlock> {
  String country = 'United States';
  String state = 'Pennsylvania';
  String county = 'Cambria County';
  String city = 'Johnstown';

  final countries = [
    'United States',
    'Canada',
    'Mexico',
    'Puerto Rico',
    'Dominican Republic',
    'United Kingdom',
    'Spain',
    'France',
    'Germany',
    'Italy',
    'Brazil',
    'Colombia',
    'Jamaica',
    'Haiti',
    'Nigeria',
    'South Africa',
    'India',
    'Philippines',
    'Australia',
  ];

  final usStates = [
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

  List<String> get states {
    if (country == 'United States') return usStates;
    return [
      '$country Region',
      '$country Province',
      '$country State',
      '$country Metro',
    ];
  }

  List<String> get counties => [
        'All Counties / Areas',
        '$state County',
        '$state Metro Area',
        '$state North Area',
        '$state South Area',
      ];

  List<String> get cities => [
        'All Cities',
        'Johnstown',
        'Bushkill',
        'East Stroudsburg',
        'Philadelphia',
        'Miami',
        'Orlando',
        'New York City',
        'Los Angeles',
        'Houston',
        '$state City Center',
      ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        drop('Country', country, countries, (v) {
          setState(() {
            country = v!;
            state = states.first;
            county = counties.first;
            city = cities.first;
          });
        }),
        drop('State / Province / Region', state, states, (v) {
          setState(() {
            state = v!;
            county = counties.first;
            city = cities.first;
          });
        }),
        drop('County / Area', county, counties, (v) {
          setState(() => county = v!);
        }),
        drop('City', city, cities, (v) {
          setState(() => city = v!);
        }),
      ],
    );
  }

  Widget drop(String label, String value, List<String> items,
      Function(String?) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: neon, width: 2.5),
        boxShadow: [
          BoxShadow(color: neon.withOpacity(.35), blurRadius: 10),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: panel,
          isExpanded: true,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          items: items.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text('$label: $e'),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
