import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/primex_sound_service.dart';

class PrimeXNotificationBell extends StatefulWidget {
  const PrimeXNotificationBell({super.key});

  @override
  State<PrimeXNotificationBell> createState() => _PrimeXNotificationBellState();
}

class _PrimeXNotificationBellState extends State<PrimeXNotificationBell> {
  int lastCount = -1;

  Future<void> ringBell() async {
    await PrimeXSoundService.bell();
  }

  Future<void> ringMessage() async {
    await PrimeXSoundService.message();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(.45),
      borderRadius: BorderRadius.circular(999),
      child: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('notifications').snapshots(),
        builder: (context, snap) {
          final count = snap.data?.docs.length ?? 0;

          if (lastCount != -1 && count > lastCount) {
            ringBell();
          }
          lastCount = count;

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  IconButton(
                    tooltip: 'Notifications',
                    icon: const Icon(Icons.notifications_active,
                        color: Color(0xFFFFD700)),
                    onPressed: ringBell,
                  ),
                  if (count > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.redAccent,
                        child: Text(
                          count > 9 ? '9+' : '$count',
                          style:
                              const TextStyle(color: Colors.white, fontSize: 9),
                        ),
                      ),
                    ),
                ],
              ),
              IconButton(
                tooltip: 'Messages',
                icon: const Icon(Icons.message, color: Color(0xFF00E5FF)),
                onPressed: ringMessage,
              ),
            ],
          );
        },
      ),
    );
  }
}
