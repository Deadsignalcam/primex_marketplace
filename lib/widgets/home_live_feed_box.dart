import 'package:flutter/material.dart';
import '../features/live_feed/live_feed_page.dart';

class HomeLiveFeedBox extends StatelessWidget {
  const HomeLiveFeedBox({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LiveFeedPage()),
      ),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF07111F),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.cyanAccent, width: 2),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final tight = constraints.maxWidth < 180;

            if (tight) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.dynamic_feed, color: Colors.cyanAccent, size: 28),
                  SizedBox(height: 6),
                  Text(
                    'LIVE FEED',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              );
            }

            return const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Icon(Icons.dynamic_feed, color: Colors.cyanAccent),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: Text(
                    'LIVE FEED',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SizedBox(width: 6),
                Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
              ],
            );
          },
        ),
      ),
    );
  }
}
