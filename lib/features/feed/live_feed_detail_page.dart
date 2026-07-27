import 'package:flutter/material.dart';

class LiveFeedDetailPage extends StatelessWidget {
  const LiveFeedDetailPage({
    super.key,
    required this.data,
  });

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final name = (data['displayName'] ?? 'Syntax Phantom').toString();
    final avatar = (data['photoUrl'] ?? '').toString();
    final text = (data['text'] ?? '').toString();
    final photos = List<String>.from(data['photoUrls'] ?? []);
    final videos = List<String>.from(data['videoUrls'] ?? []);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Live Feed Details'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/primex_jobs_bg.png',
                fit: BoxFit.cover),
          ),
          Positioned.fill(
              child: Container(color: Colors.black.withOpacity(.75))),
          ListView(
            padding: const EdgeInsets.all(14),
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.cyanAccent,
                    backgroundImage:
                        avatar.startsWith('http') ? NetworkImage(avatar) : null,
                    child: avatar.startsWith('http')
                        ? null
                        : const Icon(Icons.person, color: Colors.black),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (photos.isNotEmpty)
                SizedBox(
                  height: 260,
                  child: PageView(
                    children: photos.map((url) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(url, fit: BoxFit.cover),
                      );
                    }).toList(),
                  ),
                ),
              if (videos.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 14),
                  child: Row(
                    children: [
                      Icon(Icons.play_circle, color: Colors.greenAccent),
                      SizedBox(width: 8),
                      Text('Video attached',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              const SizedBox(height: 14),
              Text(
                text.isEmpty ? 'Photo/Video Post' : text,
                style: const TextStyle(
                    color: Colors.white, fontSize: 18, height: 1.35),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
