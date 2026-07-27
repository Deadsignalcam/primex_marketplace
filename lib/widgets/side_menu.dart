import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onSelect;

  const SideMenu({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {"icon": Icons.dashboard, "label": "Dashboard"},
      {"icon": Icons.map, "label": "Map"},
      {"icon": Icons.grid_view, "label": "Categories"},
      {"icon": Icons.groups, "label": "Leads"},
      {"icon": Icons.message, "label": "Messages"},
      {"icon": Icons.favorite_border, "label": "Saved"},
      {"icon": Icons.person_outline, "label": "Profile"},
      {"icon": Icons.settings, "label": "Settings"},
    ];

    return Container(
      width: 92,
      decoration: BoxDecoration(
        color: const Color(0xFF09111F),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.blue.withOpacity(.15),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 18),
          ShaderMask(
            shaderCallback: (bounds) {
              return const LinearGradient(
                colors: [
                  Colors.white,
                  Color(0xFF67C6FF),
                  Color(0xFF008CFF),
                ],
              ).createShader(bounds);
            },
            child: const Text(
              "PRIME X",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 14,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final selected = selectedIndex == index;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => onSelect(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: selected
                            ? Colors.blueAccent.withOpacity(.18)
                            : Colors.transparent,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            item["icon"] as IconData,
                            size: 18,
                            color: selected
                                ? Colors.lightBlueAccent
                                : Colors.white70,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item["label"] as String,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: selected ? Colors.white : Colors.white70,
                              fontWeight:
                                  selected ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
