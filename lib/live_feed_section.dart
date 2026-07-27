import 'package:flutter/material.dart';

class LiveFeedSection extends StatelessWidget {
  const LiveFeedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = [
      {
        "name": "Maria",
        "message": "Just listed a foreclosure property in PA 🔥",
      },
      {
        "name": "Carlos",
        "message": "Looking for HVAC inspectors near Johnstown.",
      },
      {
        "name": "Mike",
        "message": "Vehicle for sale • Clean title • Low miles.",
      },
    ];

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF08142E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.cyanAccent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "LIVE FEED",
            style: TextStyle(
              color: Colors.cyanAccent,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.cyanAccent,
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black.withOpacity(.25),
                    border: Border.all(
                      color: Colors.cyanAccent,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyanAccent.withOpacity(.25),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.cyanAccent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.cyanAccent.withOpacity(.5),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.cyanAccent,
                          size: 36,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post["name"]!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              post["message"]!,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                _feedButton(Icons.favorite, "Like"),
                                const SizedBox(width: 10),
                                _feedButton(Icons.comment, "Comment"),
                                const SizedBox(width: 10),
                                _feedButton(Icons.share, "Share"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _feedButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.cyanAccent,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.cyanAccent,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.cyanAccent,
            ),
          ),
        ],
      ),
    );
  }
}
