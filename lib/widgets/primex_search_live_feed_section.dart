import 'package:flutter/material.dart';
import 'home_live_feed_box.dart';

class PrimeXSearchLiveFeedSection extends StatelessWidget {
  const PrimeXSearchLiveFeedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 14, bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.45),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF00E5FF), width: 1.2),
          ),
          child: const TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              icon: Icon(Icons.search, color: Color(0xFF00E5FF)),
              hintText: 'Search PrimeX listings, posts, ads, jobs, services...',
              hintStyle:
                  TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
              border: InputBorder.none,
            ),
          ),
        ),
        HomeLiveFeedBox(),
      ],
    );
  }
}
