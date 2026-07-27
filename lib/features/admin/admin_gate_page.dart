import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth/login_page.dart';
import '../home/home_page.dart';
import 'admin_page.dart';

class AdminGatePage extends StatelessWidget {
  const AdminGatePage({super.key});

  bool isOwner(User? user) {
    final email = user?.email?.trim().toLowerCase() ?? '';
    return email == 'rosariogonzalezrosalind@gmail.com' ||
        email == 'support@primexmarketplace.com';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (isOwner(user)) {
      return const AdminPage();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Admin Private'),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF111827),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.redAccent),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock, color: Colors.redAccent, size: 64),
              const SizedBox(height: 12),
              const Text(
                'Admin is private.',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Login with the PrimeX owner account to open Admin.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const LoginPage(role: 'member')),
                  );
                },
                icon: const Icon(Icons.login),
                label: const Text('Login'),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                  );
                },
                icon: const Icon(Icons.home),
                label: const Text('Back Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
