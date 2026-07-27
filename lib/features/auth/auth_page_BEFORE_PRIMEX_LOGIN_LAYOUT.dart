import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool loginMode = true;
  bool loading = false;

  Future<void> submit() async {
    final em = email.text.trim();
    final pw = password.text.trim();

    if (em.isEmpty || pw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter email and password.')),
      );
      return;
    }

    setState(() => loading = true);

    try {
      if (loginMode) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: em,
          password: pw,
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: em,
          password: pw,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loginMode ? 'Logged in.' : 'Account created.')),
      );
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login error: $e')),
      );
    }

    if (mounted) setState(() => loading = false);
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/primex_home_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(.20)),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 285,
                    padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.72),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF00E5FF),
                        width: 1.4,
                      ),
                    ),
                    child: user != null
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'WELCOME BACK',
                                style: TextStyle(
                                  color: Color(0xFF00E5FF),
                                  fontSize: 23,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                user.email ?? 'Syntax Phantom',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'PRIMEX PRO ACTIVE',
                                style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 18),
                              ElevatedButton(
                                onPressed: logout,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('LOGOUT'),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'WELCOME BACK',
                                style: TextStyle(
                                  color: Color(0xFF00E5FF),
                                  fontSize: 23,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: email,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(color: Colors.white70),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: password,
                                obscureText: true,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(color: Colors.white70),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: loading ? null : submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00E5FF),
                                  foregroundColor: Colors.black,
                                ),
                                child: Text(
                                  loading
                                      ? 'PLEASE WAIT...'
                                      : loginMode
                                          ? 'LOGIN'
                                          : 'CREATE ACCOUNT',
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() => loginMode = !loginMode);
                                },
                                child: Text(
                                  loginMode
                                      ? 'Create new account'
                                      : 'Already have account? Login',
                                  style: const TextStyle(
                                    color: Colors.greenAccent,
                                  ),
                                ),
                              ),
                              OutlinedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Apple Login Coming Soon'),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.apple),
                                label: const Text('Apple Login Coming Soon'),
                              ),
                            ],
                          ),
                  ),
                  Positioned(
                    right: -78,
                    top: -122,
                    child: Image.asset(
                      'assets/images/primex_assistant_pro.png',
                      height: 285,
                      fit: BoxFit.contain,
                    ),
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
