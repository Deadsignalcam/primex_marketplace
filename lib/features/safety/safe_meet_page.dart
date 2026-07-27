import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class SafeMeetPage extends StatefulWidget {
  final String listingTitle;
  const SafeMeetPage({super.key, required this.listingTitle});

  @override
  State<SafeMeetPage> createState() => _SafeMeetPageState();
}

class _SafeMeetPageState extends State<SafeMeetPage> {
  int tab = 0;
  bool live = false;
  int seconds = 300;
  Timer? timer;

  Future<void> call911() async {
    await launchUrl(Uri(scheme: 'tel', path: '911'));
  }

  Future<void> shareLiveLocation() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission is required.')),
        );
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final link =
          'https://maps.google.com/?q=${pos.latitude},${pos.longitude}';
      final msg = 'PrimeX Safe Meet Live Location: $link';

      await Clipboard.setData(ClipboardData(text: msg));

      final sms = Uri(scheme: 'sms', queryParameters: {'body': msg});
      await launchUrl(sms);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Location copied and message app opened.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Share location error: $e')),
      );
    }
  }

  void startLive() {
    setState(() {
      live = true;
      tab = 1;
      seconds = 300;
    });

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => seconds--);

      if (seconds <= 0) {
        timer?.cancel();
        showSafetyCheck();
      }
    });
  }

  void showSafetyCheck() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        title:
            const Text('Safety Check', style: TextStyle(color: Colors.white)),
        content: const Text('Are you safe?',
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              startLive();
            },
            child: const Text("I'm Safe"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: call911,
            child: const Text('Call 911'),
          ),
        ],
      ),
    );
  }

  void imSafe() {
    timer?.cancel();
    setState(() {
      live = false;
      seconds = 300;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("You're marked safe.")),
    );
  }

  void saveReport(String reason) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$reason report saved for admin review.')),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget bg() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/primex_trends_bg.png',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(color: Colors.black),
        ),
        Container(color: Colors.black.withOpacity(.58)),
      ],
    );
  }

  Widget glass(Widget child) {
    return Container(
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.78),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.cyanAccent.withOpacity(.55)),
        boxShadow: [
          BoxShadow(color: Colors.cyanAccent.withOpacity(.18), blurRadius: 24),
        ],
      ),
      child: child,
    );
  }

  Widget tabs() {
    final names = ['Safe Meet', 'Live Check', 'Emergency', 'Report', 'Rules'];

    return SizedBox(
      height: 50,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        scrollDirection: Axis.horizontal,
        itemCount: names.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final active = tab == i;
          return ChoiceChip(
            selected: active,
            label: Text(names[i]),
            selectedColor: Colors.cyanAccent.withOpacity(.25),
            backgroundColor: Colors.black.withOpacity(.72),
            side:
                BorderSide(color: active ? Colors.cyanAccent : Colors.white24),
            labelStyle: TextStyle(
              color: active ? Colors.cyanAccent : Colors.white,
              fontWeight: FontWeight.bold,
            ),
            onSelected: (_) => setState(() => tab = i),
          );
        },
      ),
    );
  }

  Widget btn(IconData icon, String label, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(.78),
          foregroundColor: Colors.white,
          side: BorderSide(color: color),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget safeMeetTab() {
    return glass(Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          live ? 'LIVE SESSION ACTIVE' : 'SAFE MEET READY',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: live ? Colors.greenAccent : Colors.cyanAccent,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        const Icon(Icons.shield, color: Colors.cyanAccent, size: 76),
        const SizedBox(height: 10),
        Text(widget.listingTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        btn(Icons.play_arrow, 'Start Live Meet Session', Colors.cyanAccent,
            startLive),
        btn(Icons.check_circle, "I'm Safe", Colors.greenAccent, imSafe),
        btn(Icons.location_on, 'Share Live Location', Colors.blueAccent,
            shareLiveLocation),
        btn(Icons.report, 'Report Incident', Colors.amberAccent,
            () => setState(() => tab = 3)),
        btn(Icons.local_police, 'Emergency — Call 911', Colors.redAccent,
            call911),
      ],
    ));
  }

  Widget liveTab() {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;

    return glass(Column(
      children: [
        const Text('LIVE SAFETY CHECK',
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 18),
        Container(
          width: 175,
          height: 175,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.cyanAccent, width: 8),
          ),
          child: Text(
            '$mins:${secs.toString().padLeft(2, '0')}',
            style: const TextStyle(
                color: Colors.white, fontSize: 38, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        const Text('PrimeX checks in every 5 minutes during a meetup.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 18),
        btn(Icons.play_arrow, 'Restart 5-Min Check', Colors.cyanAccent,
            startLive),
        btn(Icons.check, "I'm Safe", Colors.greenAccent, imSafe),
        btn(Icons.phone, 'I Need Help — Call 911', Colors.redAccent, call911),
      ],
    ));
  }

  Widget emergencyTab() {
    return glass(Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('EMERGENCY CENTER',
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 14),
        btn(Icons.phone, 'Call 911', Colors.redAccent, call911),
        btn(Icons.location_on, 'Share Live Location', Colors.blueAccent,
            shareLiveLocation),
        btn(Icons.report_problem, 'Report Scam / Threat', Colors.amberAccent,
            () => setState(() => tab = 3)),
      ],
    ));
  }

  Widget reportTab() {
    final reasons = [
      'Scam',
      'Threat',
      'Fake Item',
      'Robbery',
      'Counterfeit',
      'Harassment',
      'Other'
    ];

    return glass(Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('REPORT INCIDENT',
            style: TextStyle(
                color: Colors.amberAccent,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...reasons.map(
          (r) => btn(
              Icons.report_problem, r, Colors.amberAccent, () => saveReport(r)),
        ),
      ],
    ));
  }

  Widget rulesTab() {
    return glass(const Text(
      'SAFETY FIRST\n\n'
      '✓ No public emails\n'
      '✓ No public phone numbers\n'
      '✓ Stay inside PrimeX chat\n'
      '✓ Meet in public places\n'
      '✓ Property/deed transfers: meet at title company, courthouse, attorney office, or licensed closing office\n'
      '✓ Pets may be rehomed only — animal sales are not allowed\n\n'
      'Together we build. Together we win.',
      style: TextStyle(color: Colors.white70, height: 1.5, fontSize: 15),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      safeMeetTab(),
      liveTab(),
      emergencyTab(),
      reportTab(),
      rulesTab()
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black.withOpacity(.88),
          title: const Text('PrimeX Safe Meet')),
      body: Stack(
        children: [
          bg(),
          SafeArea(
            child: Column(
              children: [
                tabs(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 24),
                    children: [pages[tab]],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
