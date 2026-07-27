import 'package:flutter/material.dart';

class PrimeXCallPage extends StatelessWidget {
  final String name;
  final String type;

  const PrimeXCallPage({
    super.key,
    required this.name,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final icon = type == 'video' ? Icons.videocam : Icons.call;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('PrimeX ${type == 'video' ? 'Video' : 'Audio'} Call')),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/primex_trends_bg.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (_, __, ___) => Container(color: Colors.black),
          ),
          Container(color: Colors.black.withOpacity(.68)),
          Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.78),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.cyanAccent),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.cyanAccent, size: 76),
                  const SizedBox(height: 14),
                  Text(
                    '${type == 'video' ? 'Video' : 'Audio'} call with $name',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'PrimeX in-app calling placeholder is wired. Connect Agora, Twilio, Zoom SDK, or WebRTC here for live production calls.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton.icon(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.call_end),
                    label: const Text('End Call'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
