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
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF07111F),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.cyanAccent, width: 2),
        ),
        child: const Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.black,
              child: Icon(Icons.dynamic_feed, color: Colors.cyanAccent),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'LIVE FEED',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 18),
          ],
        ),
      ),
    );
  }
}
