import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PrimeXProgramsJoinPage extends StatefulWidget {
  const PrimeXProgramsJoinPage({super.key});

  @override
  State<PrimeXProgramsJoinPage> createState() => _PrimeXProgramsJoinPageState();
}

class _PrimeXProgramsJoinPageState extends State<PrimeXProgramsJoinPage> {
  final fullName = TextEditingController();
  final dob = TextEditingController();
  final phone = TextEditingController();
  final referralCode = TextEditingController();
  final guardianName = TextEditingController();
  final guardianEmail = TextEditingController();

  bool youthMode = false;
  bool confirm18 = false;
  bool guardianConsent = false;
  bool loading = false;

  void msg(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> submit() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      msg('Login first, then join PrimeX Programs.');
      return;
    }

    if (fullName.text.trim().isEmpty || dob.text.trim().isEmpty) {
      msg('Enter full name and date of birth.');
      return;
    }

    if (youthMode) {
      if (!guardianConsent ||
          guardianName.text.trim().isEmpty ||
          guardianEmail.text.trim().isEmpty) {
        msg('Youth 13–17 needs guardian consent and guardian contact.');
        return;
      }
    } else {
      if (!confirm18) {
        msg('Confirm you are 18+ for the Affiliate Program.');
        return;
      }
    }

    setState(() => loading = true);

    final uid = user.uid;
    final email = user.email ?? '';
    final program = youthMode
        ? 'PrimeX Youth 13-17 Badge Program'
        : 'PrimeX Affiliate 18+ Program';
    final status = youthMode ? 'guardian_review' : 'pending';

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'displayName': fullName.text.trim(),
        'phone': phone.text.trim(),
        'dob': dob.text.trim(),
        'role': youthMode ? 'youth_badge_member' : 'affiliate_pending',
        'program': program,
        'programStatus': status,
        'affiliateStatus': youthMode ? 'youth_badges' : 'pending',
        'badgeLevel': youthMode ? 'Bronze Explorer' : '',
        'referralCode': referralCode.text.trim(),
        'guardianName': guardianName.text.trim(),
        'guardianEmail': guardianEmail.text.trim(),
        'guardianConsent': guardianConsent,
        'ageConfirmed18Plus': confirm18,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await FirebaseFirestore.instance
          .collection(
              youthMode ? 'youth_applications' : 'affiliate_applications')
          .doc(uid)
          .set({
        'uid': uid,
        'email': email,
        'fullName': fullName.text.trim(),
        'phone': phone.text.trim(),
        'dob': dob.text.trim(),
        'program': program,
        'status': status,
        'badgeLevel': youthMode ? 'Bronze Explorer' : '',
        'referralCode': referralCode.text.trim(),
        'guardianName': guardianName.text.trim(),
        'guardianEmail': guardianEmail.text.trim(),
        'guardianConsent': guardianConsent,
        'ageConfirmed18Plus': confirm18,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      msg(youthMode
          ? 'Youth badge application submitted.'
          : 'Affiliate application submitted.');

      if (mounted) Navigator.pop(context);
    } catch (e) {
      msg('Program application error: $e');
    }

    if (mounted) setState(() => loading = false);
  }

  InputDecoration input(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.cyanAccent),
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: const Color(0xFF111827),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Join PrimeX Programs'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/primex_home_bg.png'),
            fit: BoxFit.cover,
            opacity: .25,
          ),
        ),
        child: user == null
            ? const Center(
                child:
                    Text('Login first.', style: TextStyle(color: Colors.white)),
              )
            : ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.78),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.cyanAccent),
                    ),
                    child: const Text(
                      'Use your existing PrimeX account. No second signup needed.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() => youthMode = false),
                          child: const Text('Affiliate 18+'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() => youthMode = true),
                          child: const Text('Youth 13–17'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                      controller: fullName,
                      style: const TextStyle(color: Colors.white),
                      decoration: input('Full Name', Icons.person)),
                  const SizedBox(height: 10),
                  TextField(
                      controller: dob,
                      style: const TextStyle(color: Colors.white),
                      decoration: input('Date of Birth', Icons.cake)),
                  const SizedBox(height: 10),
                  TextField(
                      controller: phone,
                      style: const TextStyle(color: Colors.white),
                      decoration: input('Phone optional', Icons.phone)),
                  const SizedBox(height: 10),
                  TextField(
                      controller: referralCode,
                      style: const TextStyle(color: Colors.white),
                      decoration:
                          input('Referral Code optional', Icons.card_giftcard)),
                  const SizedBox(height: 10),
                  if (youthMode) ...[
                    TextField(
                        controller: guardianName,
                        style: const TextStyle(color: Colors.white),
                        decoration:
                            input('Guardian Name', Icons.family_restroom)),
                    const SizedBox(height: 10),
                    TextField(
                        controller: guardianEmail,
                        style: const TextStyle(color: Colors.white),
                        decoration: input('Guardian Email', Icons.email)),
                    CheckboxListTile(
                      value: guardianConsent,
                      onChanged: (v) =>
                          setState(() => guardianConsent = v ?? false),
                      title: const Text('Guardian consent confirmed.',
                          style: TextStyle(color: Colors.white)),
                      activeColor: Colors.cyanAccent,
                      checkColor: Colors.black,
                    ),
                  ] else
                    CheckboxListTile(
                      value: confirm18,
                      onChanged: (v) => setState(() => confirm18 = v ?? false),
                      title: const Text(
                          'I confirm I am 18 years of age or older.',
                          style: TextStyle(color: Colors.white)),
                      activeColor: Colors.cyanAccent,
                      checkColor: Colors.black,
                    ),
                  ElevatedButton.icon(
                    onPressed: loading ? null : submit,
                    icon: const Icon(Icons.send),
                    label:
                        Text(loading ? 'Submitting...' : 'Submit Application'),
                  ),
                ],
              ),
      ),
    );
  }
}
