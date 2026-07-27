import 'package:primex_marketplace/features/auth/login_page.dart';
import 'package:primex_marketplace/features/feed/live_feed_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:primex_marketplace/features/ai/widgets/primex_ai_floating_button.dart';
import 'features/affiliate/primex_affiliate_page.dart';
import 'features/programs/primex_programs_join_page.dart';
import 'features/youth/primex_youth_program_page.dart';
import 'features/chat/primex_messages_page.dart';
import 'features/post/primex_post_hub_page.dart';
import 'firebase_options.dart';

import 'features/home/home_page.dart';
import 'features/map/map_page.dart';
import 'features/profiles/profiles_page.dart';
import 'features/messages/messages_page.dart';
import 'features/ads/ads_promotions_page.dart';
import 'features/primex_pro/primex_pro_gate_page.dart';
import 'features/jobs/jobs_services_page.dart';
import 'features/leads/leads_page.dart';
import 'features/history/post_history_page.dart';
import 'features/admin/admin_gate_page.dart';
import 'features/auth/auth_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const PrimeXApp());
}

class PrimeXApp extends StatelessWidget {
  const PrimeXApp({super.key});

  Widget pageWithCityBackground(Widget page) {
    // Do NOT touch Home or Login/Account page backgrounds
    if (page is HomePage || page is AuthPage) {
      return page;
    }

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/primex_neon_city_two_bg.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(color: Colors.black.withOpacity(0.72)),
        ),
        Positioned.fill(child: page),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/affiliate': (context) => const PrimeXAffiliatePage(),
        '/programs': (context) => const PrimeXProgramsJoinPage(),
        '/admin': (context) => const AdminGatePage(),
        '/youth': (context) => const PrimeXYouthProgramPage(),
        '/messages': (context) => const PrimeXMessagesPage(),
        '/home': (context) => const PrimeXShell(),
      },
      title: 'PrimeX Marketplace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const PrimeXShell(),
    );
  }
}

class PrimeXShell extends StatefulWidget {
  const PrimeXShell({super.key});

  @override
  State<PrimeXShell> createState() => _PrimeXShellState();
}

class _PrimeXShellState extends State<PrimeXShell> {
  int index = 0;

  final pages = const [
    HomePage(),
    LiveFeedPage(),
    PrimeXAuthGate(child: PrimeXPostHubPage()),
    MapPage(),
    PrimeXAuthGate(child: ProfilesPage()),
    PrimeXAuthGate(child: MessagesPage()),
    AdsPromotionsPage(),
    MorePage(),
  ];

  Widget pageWithCityBackground(Widget page) {
    // Do NOT touch Home or Login/Account page backgrounds
    if (page is HomePage || page is AuthPage) {
      return page;
    }

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/primex_neon_city_two_bg.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(color: Colors.black.withOpacity(0.72)),
        ),
        Positioned.fill(child: page),
      ],
    );
  }

  Widget hardCityBackground(Widget child) {
    final keepOriginal = index == 0;

    if (keepOriginal) {
      return child;
    }

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/primex_neon_city_two_bg.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(color: Colors.black.withOpacity(0.70)),
        ),
        Positioned.fill(child: child),
      ],
    );
  }

  Widget navItem(int i, IconData icon, String label) {
    final active = index == i;
    return InkWell(
      onTap: () => setState(() => index = i),
      child: Container(
        width: 74,
        margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF00E5FF) : const Color(0xFF101522),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color:
                  active ? const Color(0xFFFFD700) : const Color(0xFF00E5FF)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 19,
                color: active ? Colors.black : const Color(0xFF00E5FF)),
            const SizedBox(height: 2),
            Text(label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 9,
                    color: active ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: hardCityBackground(pages[index]),
          ),
          if (index != 0)
            Positioned(
              right: 18,
              bottom: 18,
              child: SafeArea(
                child: PrimeXAiFloatingButton(
                  module: switch (index) {
                    0 => 'home',
                    1 => 'feed',
                    2 => 'listing_writer',
                    3 => 'map',
                    4 => 'profile',
                    5 => 'messages',
                    6 => 'ads',
                    _ => 'general',
                  },
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 64,
          color: Colors.black,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            children: [
              navItem(0, Icons.home, 'Home'),
              navItem(1, Icons.dynamic_feed, 'Feed'),
              navItem(2, Icons.add_box, 'Post'),
              navItem(3, Icons.map, 'Map'),
              navItem(4, Icons.person, 'Profile'),
              navItem(5, Icons.message, 'Chat'),
              navItem(6, Icons.campaign, 'Ads'),
            ],
          ),
        ),
      ),
    );
  }
}

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  Widget item(BuildContext context, IconData icon, String title, Widget page) {
    return Card(
      color: const Color(0xFF07101D),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF00E5FF)),
        title: Text(title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF00E5FF)),
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black, title: const Text('More PrimeX')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          item(context, Icons.login, 'Account / Login', const LoginPage()),
          item(context, Icons.handyman, 'Jobs & Services',
              const JobsServicesPage()),
          item(context, Icons.workspace_premium, 'PrimeX Pro',
              const PrimeXProGatePage()),
          item(context, Icons.leaderboard, 'Leads', const LeadsPage()),
          item(context, Icons.history, 'Post History', const PostHistoryPage()),
          item(context, Icons.admin_panel_settings, 'Admin',
              const AdminGatePage()),
        ],
      ),
    );
  }
}

class PrimeXAuthGate extends StatelessWidget {
  final Widget child;
  const PrimeXAuthGate({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
                child: CircularProgressIndicator(color: Color(0xFF00E5FF))),
          );
        }

        if (!snap.hasData) {
          return const AuthPage();
        }

        return child;
      },
    );
  }
}
