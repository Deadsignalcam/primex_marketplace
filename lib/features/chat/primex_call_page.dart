import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PrimeXCallPage extends StatefulWidget {
  final String otherUserId;
  final String otherName;
  final bool video;

  const PrimeXCallPage({
    super.key,
    required this.otherUserId,
    required this.otherName,
    required this.video,
  });

  @override
  State<PrimeXCallPage> createState() => _PrimeXCallPageState();
}

class _PrimeXCallPageState extends State<PrimeXCallPage> {
  final AudioPlayer _primeXRingPlayer = AudioPlayer();
  final player = AudioPlayer();
  String get myUid => FirebaseAuth.instance.currentUser?.uid ?? '';

  String get roomId {
    final ids = [myUid, widget.otherUserId]..sort();
    return '${ids.join('_')}_${widget.video ? 'video' : 'audio'}';
  }

  Future<void> _playPrimeXRing() async {
    try {
      await _primeXRingPlayer.setReleaseMode(ReleaseMode.loop);
      await _primeXRingPlayer.play(AssetSource('sounds/incoming_call.mp3'));
    } catch (_) {}
  }

  Future<void> _stopPrimeXRing() async {
    try {
      await _primeXRingPlayer.stop();
      await _primeXRingPlayer.dispose();
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    // Ring starts from button tap on mobile.
    startCall();
  }

  Future<void> startCall() async {
    if (myUid.isEmpty) return;

    await FirebaseFirestore.instance.collection('call_rooms').doc(roomId).set({
      'participants': [myUid, widget.otherUserId],
      'type': widget.video ? 'video' : 'audio',
      'status': 'ringing',
      'platformOnly': true,
      'wifiDataOnly': true,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    try {
      await player.play(AssetSource('sounds/incoming_call.mp3'));
    } catch (_) {}
  }

  Future<void> endCall() async {
    await player.stop();
    await FirebaseFirestore.instance.collection('call_rooms').doc(roomId).set({
      'status': 'ended',
      'endedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _stopPrimeXRing();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.video ? 'PrimeX Video Call' : 'PrimeX Audio Call';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(title), backgroundColor: Colors.black),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(18),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFF07111F),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.cyanAccent),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.video ? Icons.videocam : Icons.call,
                  color: Colors.cyanAccent, size: 80),
              const SizedBox(height: 14),
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Calling ${widget.otherName} inside PrimeX...',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              const Text('WiFi / data only. No personal phone number exposed.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.cyanAccent)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: endCall,
                icon: const Icon(Icons.call_end),
                label: const Text('End Call'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
