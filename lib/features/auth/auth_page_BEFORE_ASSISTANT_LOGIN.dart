import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/primex_social_login_buttons.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  bool isSignup = false;
  bool loading = false;
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool rememberMe = true;

  Future<void> saveUser(User user) async {
    try {
      final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final existing = await doc.get();
      final old = existing.data() ?? {};
      final ownerEmail = (user.email ?? '').toLowerCase() ==
          'rosariogonzalezrosalind@gmail.com';

      await doc.set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName ?? name.text.trim(),
        'photoUrl': user.photoURL ?? old['photoUrl'] ?? '',
        'avatarBase64': old['avatarBase64'] ?? '',
        'role': ownerEmail ? 'admin' : old['role'] ?? 'user',
        'isAdmin': ownerEmail ? true : old['isAdmin'] ?? false,
        'isOwner': ownerEmail ? true : old['isOwner'] ?? false,
        'proActive': ownerEmail ? true : old['proActive'] ?? false,
        'proPlan': old['proPlan'] ?? '',
        'status': old['status'] ?? 'active',
        'lastLoginAt': FieldValue.serverTimestamp(),
        if (!existing.exists) 'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('saveUser skipped after login: $e');
    }
  }

  Future<void> emailSubmit() async {
    final e = email.text.trim();
    final p = password.text.trim();

    if (e.isEmpty || p.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter email and password')),
      );
      return;
    }

    if (isSignup && p != confirmPassword.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => loading = true);

    try {
      UserCredential cred;

      if (isSignup) {
        cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: e,
          password: p,
        );

        await cred.user?.updateDisplayName(name.text.trim());

        await cred.user?.sendEmailVerification();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Account created. Verification email sent.')),
        );
      } else {
        cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: e,
          password: p,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged in')),
        );
      }

      await saveUser(cred.user!);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 10),
          content: Text(
              'FIREBASE LOGIN ERROR: code=${e.code} message=${e.message ?? ''}'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 10),
          content: Text('LOGIN SYSTEM ERROR: $e'),
        ),
      );
    }

    setState(() => loading = false);
  }

  Future<void> resetPassword() async {
    final e = email.text.trim();

    if (e.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your email first')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: e);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset email sent to $e')),
      );
    } on FirebaseAuthException catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Reset error: ${err.code} - ${err.message ?? ''}')),
      );
    }
  }

  Future<void> resendVerification() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login first')),
      );
      return;
    }

    await user.sendEmailVerification();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Verification email sent')),
    );
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    setState(() {});
  }

  Widget input(
    TextEditingController c,
    String label,
    IconData icon, {
    bool obscure = false,
    VoidCallback? toggle,
    bool? hidden,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextField(
        controller: c,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white70),
          suffixIcon: toggle == null
              ? null
              : IconButton(
                  icon: Icon(
                    hidden == true ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xFF00E5FF),
                  ),
                  onPressed: toggle,
                ),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: const Color(0xDD101522),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget choice(String text, bool selected, VoidCallback tap) {
    return Expanded(
      child: InkWell(
        onTap: tap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF00E5FF) : Colors.black,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF00E5FF)),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.black : const Color(0xFF00E5FF),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget loginView() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text(
          'PRIME X',
          style: TextStyle(
            color: Colors.white,
            fontSize: 46,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        const Text(
          'MARKETPLACE',
          style: TextStyle(
            color: Color(0xFF00E5FF),
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
        const Text(
          'SELL • BUY • CONNECT • GROW',
          style: TextStyle(color: Colors.white70, letterSpacing: 3),
        ),
        const SizedBox(height: 360),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: panel(),
          child: Column(
            children: [
              Row(
                children: [
                  choice('LOGIN', !isSignup,
                      () => setState(() => isSignup = false)),
                  const SizedBox(width: 8),
                  choice('SIGN UP', isSignup,
                      () => setState(() => isSignup = true)),
                ],
              ),
              if (isSignup) input(name, 'Full Name', Icons.person),
              input(email, 'Email Address', Icons.email),
              input(
                password,
                'Password',
                Icons.lock,
                obscure: hidePassword,
                hidden: hidePassword,
                toggle: () => setState(() => hidePassword = !hidePassword),
              ),
              if (isSignup)
                input(
                  confirmPassword,
                  'Confirm Password',
                  Icons.lock_outline,
                  obscure: hideConfirmPassword,
                  hidden: hideConfirmPassword,
                  toggle: () => setState(
                      () => hideConfirmPassword = !hideConfirmPassword),
                ),
              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    activeColor: const Color(0xFF00E5FF),
                    onChanged: (v) => setState(() => rememberMe = v ?? true),
                  ),
                  const Text('Remember me',
                      style: TextStyle(color: Colors.white70)),
                  const Spacer(),
                  TextButton(
                    onPressed: resetPassword,
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                          color: Color(0xFFFFD700),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: loading ? null : emailSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00E5FF),
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: Text(
                  loading
                      ? 'PLEASE WAIT...'
                      : isSignup
                          ? 'CREATE ACCOUNT'
                          : 'LOGIN',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              const PrimeXSocialLoginButtons(),
              const SizedBox(height: 10),
              const Text(
                'PrimeX Pro opens after membership payment. Admin opens only for owner/admin accounts.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget loggedInView(User user) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
      builder: (context, snap) {
        final data = snap.data?.data() as Map<String, dynamic>? ?? {};
        final isAdmin = data['isAdmin'] == true ||
            data['isOwner'] == true ||
            data['role'] == 'admin';
        final pro = data['proActive'] == true;

        return Center(
          child: Container(
            margin: const EdgeInsets.all(18),
            padding: const EdgeInsets.all(18),
            decoration: panel(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'WELCOME BACK',
                  style: TextStyle(
                      color: Color(0xFF00E5FF),
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(user.email ?? 'Syntax Phantom',
                    style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  isAdmin
                      ? 'ADMIN / OWNER ACCESS'
                      : pro
                          ? 'PRIMEX PRO ACTIVE'
                          : 'STANDARD MEMBER',
                  style: TextStyle(
                    color: isAdmin
                        ? const Color(0xFFFFD700)
                        : pro
                            ? Colors.greenAccent
                            : Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!user.emailVerified)
                  TextButton(
                    onPressed: resendVerification,
                    child: const Text('Resend Email Verification',
                        style: TextStyle(color: Color(0xFFFFD700))),
                  ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: logout,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent),
                  child: const Text('LOGOUT'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static BoxDecoration panel() => BoxDecoration(
        color: const Color(0xEE101522),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF00E5FF)),
        boxShadow: const [BoxShadow(color: Color(0x3300E5FF), blurRadius: 14)],
      );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        final user = snap.data;

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/primex_login_bg.png',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(color: Colors.black.withOpacity(0.20)),
              ),
              SafeArea(
                child: user == null ? loginView() : loggedInView(user),
              ),
            ],
          ),
        );
      },
    );
  }
}
