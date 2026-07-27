import 'package:flutter/material.dart';

import 'dashboard_screen.dart';
import 'map_screen.dart';
import 'categories_screen.dart';
import 'post_screen.dart';
import 'live_feed_screen.dart';
import 'calls_messages_screen.dart';
import 'admin_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int currentIndex = 0;

  final pages = [
    const DashboardScreen(),
    const MapScreen(),
    const CategoriesScreen(),
    const PostScreen(),
    const LiveFeedScreen(),
    const CallsMessagesScreen(),
    const AdminScreen(),
  ];

  final items = [
    "Dashboard",
    "Map",
    "Categories",
    "Post",
    "Live Feed",
    "Calls & Messages",
    "Admin",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff050816),
      body: SafeArea(
        child: Row(
          children: [
            Container(
              width: 170,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff091336),
                    Color(0xff111b4d),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "PrimeX",
                    style: TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "SELL • BUY • CONNECT • GROW",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final active = currentIndex == index;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                currentIndex = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              height: 58,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: active
                                    ? Colors.cyanAccent.withOpacity(.20)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: Colors.cyanAccent,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.cyanAccent.withOpacity(.35),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  items[index],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      height: 65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.cyanAccent,
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "SYNTAX\nPHANTOM",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.cyanAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: pages[currentIndex],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
