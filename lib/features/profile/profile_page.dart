import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  String safeName(User? user) {
    final name = user?.displayName;
    if (name != null && name.trim().isNotEmpty) return name.trim();
    return 'PrimeX Member';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF050816),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('PrimeX Profile'),
        centerTitle: true,
      ),
      body: user == null
          ? Center(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Login to view your profile'),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF081B3A), Color(0xFF0B0B12)],
                      ),
                      border: Border.all(color: Color(0xFF00E5FF), width: 1.4),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x6600E5FF),
                          blurRadius: 24,
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 58,
                          backgroundColor: Colors.cyanAccent,
                          backgroundImage: user.photoURL != null
                              ? NetworkImage(user.photoURL!)
                              : null,
                          child: user.photoURL == null
                              ? const Icon(Icons.person,
                                  size: 62, color: Colors.black)
                              : null,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          safeName(user),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Email hidden for privacy',
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 18),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit Profile Photo / Info'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  _card(
                    icon: Icons.workspace_premium,
                    title: 'PrimeX Badges',
                    body: 'Earn 5 badges and get one month free on us.',
                  ),
                  _card(
                    icon: Icons.verified_user,
                    title: 'Safe Marketplace Rules',
                    body:
                        'No abuse, no nudity, no dating, no scams, and no sharing private numbers inside chat.',
                  ),
                  _card(
                    icon: Icons.auto_awesome,
                    title: 'AI Assistant Protection',
                    body:
                        'PrimeX AI helps monitor posts, listings, chats, and marketplace safety.',
                  ),
                  _card(
                    icon: Icons.public,
                    title: 'Global Profile',
                    body:
                        'Your profile connects to listings, ads, jobs, services, property posts, and global selling.',
                  ),
                ],
              ),
            ),
    );
  }

  Widget _card({
    required IconData icon,
    required String title,
    required String body,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0C1024),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF00E5FF), size: 34),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(body,
                    style:
                        const TextStyle(color: Colors.white70, height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
