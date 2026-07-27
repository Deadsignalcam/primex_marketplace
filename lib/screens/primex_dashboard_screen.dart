import 'package:flutter/material.dart';

class PrimeXDashboardScreen extends StatelessWidget {
  const PrimeXDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff02030a),
      body: Stack(
        children: const [
          _CyberBackground(),
          _DashboardLayout(),
        ],
      ),
    );
  }
}

class _DashboardLayout extends StatelessWidget {
  const _DashboardLayout();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _Sidebar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 8),
                      _TopCards(),
                      SizedBox(height: 20),
                      Text(
                        'LIVE FEED',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                          shadows: [
                            Shadow(color: Colors.cyanAccent, blurRadius: 10)
                          ],
                        ),
                      ),
                      SizedBox(height: 14),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _ListingCard(),
                              SizedBox(height: 18),
                              _ListingCard(isNew: true),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 22),
                const Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _QuickActions(),
                        SizedBox(height: 18),
                        _MarketplaceStats(),
                        SizedBox(height: 18),
                        _RecentLeads(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CyberBackground extends StatelessWidget {
  const _CyberBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CyberPainter(),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff02010a),
              Color(0xff07135a),
              Color(0xff010205),
            ],
          ),
        ),
      ),
    );
  }
}

class _CyberPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cyanGlow = Paint()
      ..color = Colors.cyanAccent.withOpacity(.45)
      ..strokeWidth = 7
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);

    final cyan = Paint()
      ..color = Colors.cyanAccent
      ..strokeWidth = 2;

    final purple = Paint()
      ..color = Colors.purpleAccent.withOpacity(.9)
      ..strokeWidth = 2;

    final building = Paint()..color = Colors.black.withOpacity(.48);

    final cityY = size.height * .22;

    double x = 250;

    for (int i = 0; i < 16; i++) {
      final w = 55.0 + (i % 4) * 22;
      final h = 120.0 + (i % 5) * 45;
      final top = cityY - h;

      canvas.drawRect(
        Rect.fromLTWH(x, top, w, h),
        building,
      );

      canvas.drawLine(
        Offset(x, top + 16),
        Offset(x + w, top + 16),
        i.isEven ? cyan : purple,
      );

      for (double wy = top + 35; wy < top + h - 15; wy += 18) {
        for (double wx = x + 8; wx < x + w - 8; wx += 14) {
          canvas.drawRect(
            Rect.fromLTWH(wx, wy, 4, 4),
            Paint()
              ..color = i.isEven
                  ? Colors.cyanAccent.withOpacity(.3)
                  : Colors.purpleAccent.withOpacity(.3),
          );
        }
      }

      x += w + 12;
    }

    final bolt = Path()
      ..moveTo(size.width * .74, 0)
      ..lineTo(size.width * .70, 85)
      ..lineTo(size.width * .77, 145)
      ..lineTo(size.width * .71, 225)
      ..lineTo(size.width * .80, 315);

    canvas.drawPath(bolt, cyanGlow);
    canvas.drawPath(bolt, cyan);

    final bolt2 = Path()
      ..moveTo(size.width * .92, 10)
      ..lineTo(size.width * .87, 95)
      ..lineTo(size.width * .93, 180)
      ..lineTo(size.width * .89, 270);

    canvas.drawPath(bolt2, cyanGlow);
    canvas.drawPath(bolt2, cyan);

    final horizon = size.height * .28;

    canvas.drawLine(
      Offset(0, horizon),
      Offset(size.width, horizon),
      cyanGlow,
    );

    canvas.drawLine(
      Offset(0, horizon),
      Offset(size.width, horizon),
      cyan,
    );

    final grid = Paint()
      ..color = Colors.cyanAccent.withOpacity(.13)
      ..strokeWidth = 1;

    for (double y = horizon + 30; y < size.height; y += 38) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    for (double gx = -size.width; gx < size.width * 2; gx += 70) {
      canvas.drawLine(
        Offset(size.width / 2, horizon),
        Offset(gx, size.height),
        grid,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Sidebar extends StatelessWidget {
  const _Sidebar();

  @override
  Widget build(BuildContext context) {
    final items = [
      'Dashboard',
      'Map',
      'Categories',
      'Post',
      'Leads',
      'Messages',
      'Saved',
      'Profile',
      'Settings'
    ];

    return Container(
      width: 290,
      padding: const EdgeInsets.all(10),
      color: Colors.black.withOpacity(.62),
      child: Column(
        children: [
          const SizedBox(height: 8),

          // PRIME X LOGO
          Row(
            children: const [
              Text(
                'PRIME',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: Colors.white,
                  shadows: [
                    Shadow(color: Colors.white54, blurRadius: 10),
                  ],
                ),
              ),
              Text(
                'X',
                style: TextStyle(
                  fontSize: 62,
                  fontWeight: FontWeight.w900,
                  color: Colors.blueAccent,
                  shadows: [
                    Shadow(color: Colors.cyanAccent, blurRadius: 28),
                    Shadow(color: Colors.blueAccent, blurRadius: 50),
                  ],
                ),
              ),
            ],
          ),

          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                'M A R K E T P L A C E',
                style: TextStyle(
                  color: Colors.cyanAccent,
                  letterSpacing: 6,
                  fontSize: 11,
                ),
              ),
            ),
          ),

          const SizedBox(height: 22),

          for (final item in items)
            Container(
              height: 56,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: item == 'Dashboard'
                    ? Colors.cyanAccent.withOpacity(.18)
                    : Colors.black.withOpacity(.35),
                border: Border.all(
                  color: item == 'Dashboard'
                      ? Colors.cyanAccent
                      : Colors.cyanAccent.withOpacity(.18),
                ),
                boxShadow: item == 'Dashboard'
                    ? [
                        BoxShadow(
                          color: Colors.cyanAccent.withOpacity(.4),
                          blurRadius: 10,
                        ),
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 18),
                  Icon(
                    Icons.circle_outlined,
                    size: 18,
                    color: item == 'Dashboard'
                        ? Colors.cyanAccent
                        : Colors.white70,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    item,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),

          const Spacer(),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: _glass(Colors.cyanAccent),
            child: Column(
              children: const [
                Text(
                  'POWERED BY',
                  style: TextStyle(
                    color: Colors.cyanAccent,
                    letterSpacing: 4,
                    fontSize: 10,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'SYNTAX PHANTOM',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '@ 2026',
                  style: TextStyle(
                    color: Colors.cyanAccent,
                    letterSpacing: 4,
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

class _TopCards extends StatelessWidget {
  const _TopCards();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _Card(title: 'Active Listings', value: '1')),
        SizedBox(width: 18),
        Expanded(child: _Card(title: 'Views Today', value: '1,245')),
        SizedBox(width: 18),
        Expanded(child: _Card(title: 'PrimeX Plan', value: 'Investor')),
        SizedBox(width: 18),
        Expanded(
          child: _Card(
            title: 'PRIMEX ADS',
            value:
                'Ad slot 25 dollars per week\nBusinesses can advertise here.',
            small: true,
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final String value;
  final bool small;

  const _Card({
    required this.title,
    required this.value,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 122,
      padding: const EdgeInsets.all(10),
      decoration: _glass(Colors.cyanAccent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: Colors.cyanAccent,
              fontSize: small ? 15 : 34,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ListingCard extends StatelessWidget {
  final bool isNew;

  const _ListingCard({this.isNew = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: _glass(
        isNew ? Colors.purpleAccent : Colors.cyanAccent,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff8f3dff),
                        Color(0xff2f6cff),
                        Color(0xff111827),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _miniBox(),
                    const SizedBox(height: 12),
                    _miniBox(),
                    const SizedBox(height: 12),
                    _miniBox(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniBox() {
    return Container(
      height: 112,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.black.withOpacity(.55),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return _rightBox(
      'QUICK ACTIONS',
      Colors.purpleAccent,
    );
  }
}

class _MarketplaceStats extends StatelessWidget {
  const _MarketplaceStats();

  @override
  Widget build(BuildContext context) {
    return _rightBox(
      'MARKETPLACE STATS',
      Colors.cyanAccent,
    );
  }
}

class _RecentLeads extends StatelessWidget {
  const _RecentLeads();

  @override
  Widget build(BuildContext context) {
    return _rightBox(
      'RECENT LEADS',
      Colors.cyanAccent,
    );
  }
}

Widget _rightBox(String title, Color color) {
  return Container(
    width: double.infinity,
    height: 240,
    padding: const EdgeInsets.all(12),
    decoration: _glass(color),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 14,
        color: color,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

BoxDecoration _glass(Color glow) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(18),
    color: const Color(0xff050816).withOpacity(.66),
    border: Border.all(
      color: glow.withOpacity(.55),
    ),
    boxShadow: [
      BoxShadow(
        color: glow.withOpacity(.35),
        blurRadius: 28,
      ),
    ],
  );
}
