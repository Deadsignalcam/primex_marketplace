import 'package:flutter/material.dart';

class PrimeXHomeThreeTabs extends StatelessWidget {
  const PrimeXHomeThreeTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _PrimeXHomeTab(icon: Icons.campaign, label: 'Ads')),
        SizedBox(width: 8),
        Expanded(
            child: _PrimeXHomeTab(icon: Icons.rss_feed, label: 'Live Feed')),
        SizedBox(width: 8),
        Expanded(
            child: _PrimeXHomeTab(
                icon: Icons.workspace_premium, label: 'PrimeX Pro')),
      ],
    );
  }
}

class _PrimeXHomeTab extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PrimeXHomeTab({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.45),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00E5FF)),
        boxShadow: const [
          BoxShadow(color: Color(0x4400E5FF), blurRadius: 12),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF00E5FF), size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
