import 'package:flutter/material.dart';

class PrimeOwnerCommandCenter extends StatefulWidget {
  const PrimeOwnerCommandCenter({super.key});

  @override
  State<PrimeOwnerCommandCenter> createState() =>
      _PrimeOwnerCommandCenterState();
}

class _PrimeOwnerCommandCenterState extends State<PrimeOwnerCommandCenter> {
  int tab = 0;

  final tabs = const [
    'Listings',
    'Live Feed',
    'Ads & Promotions',
    'Jobs & Services',
    'Lead Data',
    'Users',
    'Reports',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050814),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Prime Owner Command Center'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 58,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              itemCount: tabs.length,
              itemBuilder: (context, i) {
                final selected = tab == i;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    selected: selected,
                    label: Text(tabs[i]),
                    onSelected: (_) => setState(() => tab = i),
                    selectedColor: Colors.cyanAccent,
                    backgroundColor: const Color(0xFF111827),
                    labelStyle: TextStyle(
                      color: selected ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(child: _screen()),
        ],
      ),
    );
  }

  Widget _screen() {
    switch (tab) {
      case 0:
        return const _OwnerPanel(
          title: 'All Listings Control',
          items: [
            'Review new listings',
            'Edit listing',
            'Delete listing',
            'Approve / reject listing',
            'Boost listing',
            'Pin listing to map',
            'Mark sold / active / pending',
          ],
        );
      case 1:
        return const _OwnerPanel(
          title: 'Live Feed Control',
          items: [
            'View all live posts',
            'Edit live feed post',
            'Delete live feed post',
            'Approve photos / videos',
            'Pin post to homepage',
            'Boost post',
          ],
        );
      case 2:
        return const _OwnerPanel(
          title: 'LIVE ADS & PROMOTIONS',
          items: [
            'Standard Ad Space',
            'Business Spotlight',
            'Homepage Banner',
            'Boost 4 Days',
            'Boost 15 Days',
            'Realtor / Broker / Vehicle 35 Days',
            'Sheriff / Tax / Foreclosure Monthly',
          ],
        );
      case 3:
        return const _OwnerPanel(
          title: 'Jobs & Services Control',
          items: [
            'Review job posts',
            'Review service providers',
            'Approve paid services',
            'Edit job/service listings',
            'Remove bad posts',
          ],
        );
      case 4:
        return const _OwnerPanel(
          title: 'Lead Data Control',
          items: [
            'Foreclosure leads',
            'Sheriff sale leads',
            'Tax sale leads',
            'Map pin control',
            'PrimeX Pro lead access',
          ],
        );
      case 5:
        return const _OwnerPanel(
          title: 'User Control',
          items: [
            'View users',
            'Remove private emails from public view',
            'Manage badges',
            'Suspend abusive accounts',
            'Review reports',
          ],
        );
      default:
        return const _OwnerPanel(
          title: 'Reports & Safety',
          items: [
            'Reported listings',
            'Reported users',
            'Adult content reports',
            'Scam reports',
            'AI moderation queue',
          ],
        );
    }
  }
}

class _OwnerPanel extends StatelessWidget {
  final String title;
  final List<String> items;

  const _OwnerPanel({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),
        ...items.map(
          (item) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0B1020),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.cyanAccent.withOpacity(.35)),
            ),
            child: Row(
              children: [
                const Icon(Icons.admin_panel_settings,
                    color: Colors.cyanAccent),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.white54),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
