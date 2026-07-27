import 'package:flutter/material.dart';

class LiveFeedPagePost extends StatefulWidget {
  const LiveFeedPagePost({super.key});

  @override
  State<LiveFeedPagePost> createState() => _LiveFeedPagePostState();
}

class _LiveFeedPagePostState extends State<LiveFeedPagePost> {
  final TextEditingController _controller = TextEditingController(
    text:
        'God is love. Very soon you will smile and say, God this is more than I prayed for. Psalm 126:3',
  );

  String savedPost =
      'God is love. Very soon you will smile and say, God this is more than I prayed for. Psalm 126:3';

  void savePost() {
    setState(() {
      savedPost = _controller.text.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.cyanAccent, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.25),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'LIVE FEED POST',
            style: TextStyle(
              color: Colors.cyanAccent,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Write your live feed post...',
              hintStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Colors.white.withOpacity(0.08),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              onPressed: savePost,
              child: const Text('Save Live Feed Post'),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PrimeX Community Update',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  savedPost,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
