import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/primex_sound_service.dart';

class PrimeXSoundAutopilot extends StatefulWidget {
  const PrimeXSoundAutopilot({super.key});

  @override
  State<PrimeXSoundAutopilot> createState() => _PrimeXSoundAutopilotState();
}

class _PrimeXSoundAutopilotState extends State<PrimeXSoundAutopilot> {
  int notifications = -1;
  int messages = -1;
  int calls = -1;

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('notifications')
        .snapshots()
        .listen((snap) {
      if (notifications != -1 && snap.docs.length > notifications) {
        PrimeXSoundService.bell();
      }
      notifications = snap.docs.length;
    });

    FirebaseFirestore.instance
        .collection('messages')
        .snapshots()
        .listen((snap) {
      if (messages != -1 && snap.docs.length > messages) {
        PrimeXSoundService.message();
      }
      messages = snap.docs.length;
    });

    FirebaseFirestore.instance.collection('calls').snapshots().listen((snap) {
      if (calls != -1 && snap.docs.length > calls) {
        PrimeXSoundService.call();
      }
      calls = snap.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
