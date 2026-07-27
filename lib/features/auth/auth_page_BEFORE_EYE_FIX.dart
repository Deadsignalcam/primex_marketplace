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
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: em, password: pw);
      } else {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: em, password: pw);
      }
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login error: $e')),
        );
      }
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
            child: Image.asset('assets/images/primex_login_bg.png',
                fit: BoxFit.cover),
          ),
          Positioned.fill(
              child: Container(color: Colors.black.withOpacity(.16))),
          Positioned(
            left: 14,
            top: 34,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('PRIME X',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1)),
                SizedBox(height: 4),
                Text('MARKETPLACE',
                    style: TextStyle(
                        color: Color(0xFF00E5FF),
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2)),
                SizedBox(height: 2),
                Text('SELL • BUY • CONNECT • GROW',
                    style: TextStyle(
                        color: Colors.white70, fontSize: 11, letterSpacing: 2)),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 430, 10, 90),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.72),
                  borderRadius: BorderRadius.circular(18),
                  border:
                      Border.all(color: const Color(0xFF00E5FF), width: 1.5),
                ),
                child: user != null
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('WELCOME BACK',
                              style: TextStyle(
                                  color: Color(0xFF00E5FF),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900)),
                          const SizedBox(height: 8),
                          Text(user.email ?? 'Syntax Phantom',
                              style: const TextStyle(color: Colors.white)),
                          const SizedBox(height: 8),
                          const Text('PRIMEX PRO ACTIVE',
                              style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.w900)),
                          const SizedBox(height: 14),
                          ElevatedButton(
                            onPressed: logout,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white),
                            child: const Text('LOGOUT'),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () =>
                                      setState(() => loginMode = true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: loginMode
                                        ? const Color(0xFF00E5FF)
                                        : Colors.black,
                                    foregroundColor: loginMode
                                        ? Colors.black
                                        : const Color(0xFF00E5FF),
                                    side: const BorderSide(
                                        color: Color(0xFF00E5FF)),
                                  ),
                                  child: const Text('LOGIN'),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () =>
                                      setState(() => loginMode = false),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: !loginMode
                                        ? const Color(0xFF00E5FF)
                                        : Colors.black,
                                    foregroundColor: !loginMode
                                        ? Colors.black
                                        : const Color(0xFF00E5FF),
                                    side: const BorderSide(
                                        color: Color(0xFF00E5FF)),
                                  ),
                                  child: const Text('SIGN UP'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: email,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              prefixIcon:
                                  Icon(Icons.email, color: Colors.white70),
                              hintText: 'Email Address',
                              hintStyle: TextStyle(color: Colors.white60),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: password,
                            obscureText: true,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              prefixIcon:
                                  Icon(Icons.lock, color: Colors.white70),
                              suffixIcon: Icon(Icons.visibility_off,
                                  color: Color(0xFF00E5FF)),
                              hintText: 'Password',
                              hintStyle: TextStyle(color: Colors.white60),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: loading ? null : submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00E5FF),
                              foregroundColor: Colors.black,
                              minimumSize: const Size(double.infinity, 45),
                            ),
                            child: Text(
                              loading
                                  ? 'PLEASE WAIT...'
                                  : loginMode
                                      ? 'LOGIN'
                                      : 'CREATE ACCOUNT',
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
