import 'package:flutter/material.dart';

class CommunityFeed extends StatelessWidget {
  const CommunityFeed({super.key});

  static const _items = [
    {
      "name": "Sarah Johnson",
      "place": "Johnstown, PA",
      "text": "Just listed a new property near downtown Johnstown."
    },
    {
      "name": "Mike Williams",
      "place": "Johnstown, PA",
      "text": "Market is heating up. Prices moving fast."
    },
    {
      "name": "Jessica Lee",
      "place": "Johnstown, PA",
      "text": "Looking for a 3 bed home. Any leads?"
    },
    {
      "name": "Tools Market",
      "place": "Johnstown, PA",
      "text": "New inspection tool kit posted."
    },
    {
      "name": "PrimeX Alerts",
      "place": "Cambria County, PA",
      "text": "New foreclosure lead added."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        final name = item["name"]!;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2332),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: const Color(0xFFD7A847),
                child: Text(
                  name.substring(0, 1),
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$name • ${item["place"]}",
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item["text"]!,
                      style: const TextStyle(color: Colors.white70, fontSize: 10),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chat_bubble_outline, color: Colors.white54, size: 14),
            ],
          ),
        );
      },
    );
  }
}
