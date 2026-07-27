import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../features/auth/login_page.dart';

class PrimeXProGate extends StatelessWidget {
  final Widget child;

  const PrimeXProGate({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text(
          'Login first to access PrimeX Pro tools.',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snap) {
        final d = snap.data?.data() as Map<String, dynamic>? ?? {};
        final active = d['primeXPro'] == true || d['proStatus'] == 'active';

        if (active) return child;

        return Center(
          child: Container(
            margin: const EdgeInsets.all(18),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF061125).withOpacity(.86),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF00E5FF)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.workspace_premium,
                    color: Color(0xFF00E5FF), size: 52),
                SizedBox(height: 12),
                Text(
                  'PrimeX Pro Required',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Upgrade to access lead data, foreclosure tools, comps, job/service leads, and Pro map pins.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
