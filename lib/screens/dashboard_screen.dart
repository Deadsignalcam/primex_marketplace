import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth;
            final compact = w < 950;

            return Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topLeft,
                  radius: 1.4,
                  colors: [Color(0xFF061A35), AppTheme.bg],
                ),
              ),
              child: Row(
                children: [
                  if (!compact) const _SideBar(),
                  if (!compact) const SizedBox(width: 18),
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        const _TopHeader(),
                        const SizedBox(height: 12),
                        const _Filters(),
                        const SizedBox(height: 12),
                        const Expanded(flex: 7, child: _MapPanel()),
                        const SizedBox(height: 12),
                        const Expanded(flex: 5, child: _BottomListings()),
                        const SizedBox(height: 10),
                        const _BottomNav(),
                      ],
                    ),
                  ),
                  if (!compact) const SizedBox(width: 16),
                  if (!compact)
                    const SizedBox(width: 250, child: _RightPanel()),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CardBox extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const _CardBox(
      {required this.child, this.padding = const EdgeInsets.all(14)});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppTheme.panel.withOpacity(.88),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
        boxShadow: [
          BoxShadow(
            color: AppTheme.blue.withOpacity(.08),
            blurRadius: 22,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SideBar extends StatelessWidget {
  const _SideBar();

  @override
  Widget build(BuildContext context) {
    final items = [
      ['▦', 'Dashboard'],
      ['◧', 'Map'],
      ['▦', 'Categories'],
      ['♙', 'Leads'],
      ['☷', 'Messages'],
      ['♡', 'Saved'],
      ['♙', 'Profile'],
      ['⚙', 'Settings'],
    ];

    return SizedBox(
      width: 270,
      child: _CardBox(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Container(
              height: 110,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF081324),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 34,
                    letterSpacing: 8,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(text: 'PRIME'),
                    TextSpan(
                      text: 'X',
                      style: TextStyle(
                        color: AppTheme.blue,
                        fontSize: 58,
                        shadows: [
                          Shadow(color: AppTheme.blue, blurRadius: 24),
                          Shadow(color: Colors.white, blurRadius: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            ...items.asMap().entries.map((e) {
              final active = e.key == 0;
              return Container(
                height: 48,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: active ? AppTheme.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: active ? Border.all(color: Colors.blueAccent) : null,
                ),
                child: Row(
                  children: [
                    Text(e.value[0], style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 14),
                    Text(
                      e.value[1],
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            }),
            const Spacer(),
            _CardBox(
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PrimeX Plan', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 4),
                    Text('Investor',
                        style: TextStyle(
                            fontSize: 28,
                            color: AppTheme.gold,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    Text('Manage Plan',
                        style: TextStyle(color: AppTheme.blue, fontSize: 16)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  const _TopHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'PrimeX Marketplace',
            style: TextStyle(
              fontSize: 46,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        _topButton('+  Post Lead', AppTheme.gold),
        const SizedBox(width: 12),
        _topButton('☷  More Filters', AppTheme.blue),
      ],
    );
  }

  Widget _topButton(String text, Color color) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(text,
            style: TextStyle(
                color: color, fontSize: 16, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters();

  @override
  Widget build(BuildContext context) {
    final filters = [
      ['Country', 'United States'],
      ['State', 'Pennsylvania'],
      ['County', 'Cambria County'],
      ['City', 'Johnstown'],
    ];

    return Row(
      children: [
        ...filters.map(
          (f) => Expanded(
            child: Container(
              height: 58,
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppTheme.panel,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(f[0],
                            style: const TextStyle(
                                color: AppTheme.muted, fontSize: 12)),
                        Text(f[1], style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, size: 18),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 58,
          width: 62,
          decoration: BoxDecoration(
            color: AppTheme.panel,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.border),
          ),
          child: const Icon(Icons.tune),
        ),
      ],
    );
  }
}

class _MapPanel extends StatelessWidget {
  const _MapPanel();

  @override
  Widget build(BuildContext context) {
    return _CardBox(
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _MapPainter())),
          const Center(
            child: Text('Johnstown',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
          ),
          const Positioned(
              top: 18, left: 18, child: _SmallButton('⬚  Draw Search')),
          const Positioned(top: 62, left: 18, child: _MapToggle()),
          const _Pin(left: .28, top: .16, price: '\$145K', blue: true),
          const _Pin(left: .52, top: .16, price: '\$220K', blue: false),
          const _Pin(left: .78, top: .16, price: '\$89K', blue: true),
          const _Pin(left: .23, top: .56, price: '\$120K', blue: true),
          const _Pin(left: .57, top: .76, price: '\$75K', blue: true),
          const _Pin(left: .78, top: .58, price: '\$310K', blue: false),
          Positioned(
            right: 16,
            bottom: 18,
            child: Container(
              width: 44,
              height: 118,
              decoration: BoxDecoration(
                color: AppTheme.panel,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.border),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.add),
                  Icon(Icons.remove),
                  Icon(Icons.my_location, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = AppTheme.blue.withOpacity(.10)
      ..strokeWidth = .8;

    for (double x = 0; x < size.width; x += 28) {
      canvas.drawLine(
          Offset(x, 0), Offset(x + size.height * .45, size.height), grid);
    }
    for (double y = 0; y < size.height; y += 22) {
      canvas.drawLine(
          Offset(0, y), Offset(size.width, y + size.width * .05), grid);
    }

    final road = Paint()
      ..color = AppTheme.blue.withOpacity(.22)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 7; i++) {
      final path = Path()
        ..moveTo(0, size.height * (.18 + i * .11))
        ..quadraticBezierTo(
          size.width * .45,
          size.height * (.1 + i * .09),
          size.width,
          size.height * (.22 + i * .08),
        );
      canvas.drawPath(path, road);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Pin extends StatelessWidget {
  final double left;
  final double top;
  final String price;
  final bool blue;
  const _Pin(
      {required this.left,
      required this.top,
      required this.price,
      required this.blue});

  @override
  Widget build(BuildContext context) {
    final color = blue ? AppTheme.blue : AppTheme.gold;
    return Positioned.fill(
      child: FractionallySizedBox(
        alignment: Alignment(left * 2 - 1, top * 2 - 1),
        widthFactor: .12,
        heightFactor: .22,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.panel,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: color),
              ),
              child: Text(price,
                  style: TextStyle(
                      color: color, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            Icon(Icons.location_pin, color: color, size: 34),
          ],
        ),
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  final String text;
  const _SmallButton(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.panel,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Center(child: Text(text)),
    );
  }
}

class _MapToggle extends StatelessWidget {
  const _MapToggle();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 34,
          width: 62,
          decoration: const BoxDecoration(
            color: AppTheme.blue,
            borderRadius: BorderRadius.horizontal(left: Radius.circular(7)),
          ),
          child: const Center(child: Text('Map')),
        ),
        Container(
          height: 34,
          width: 82,
          decoration: BoxDecoration(
            color: AppTheme.panel,
            borderRadius:
                const BorderRadius.horizontal(right: Radius.circular(7)),
            border: Border.all(color: AppTheme.border),
          ),
          child: const Center(child: Text('Satellite')),
        ),
      ],
    );
  }
}

class _BottomListings extends StatelessWidget {
  const _BottomListings();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 220, child: _CategoriesBox()),
        const SizedBox(width: 14),
        const Expanded(child: _FeaturedListings()),
      ],
    );
  }
}

class _CategoriesBox extends StatelessWidget {
  final items = const [
    ['⌂', 'Real Estate', '12,458'],
    ['⌂', 'Housing', '8,920'],
    ['▦', 'Rentals', '6,230'],
    ['⚒', 'Foreclosures', '2,450'],
    ['▣', 'For Sale', '15,980'],
    ['▣', 'Jobs', '10,230'],
    ['⚲', 'Services', '9,120'],
    ['▥', 'Community', '4,560'],
    ['▦', 'Events', '10,120'],
    ['♣', 'Pets', '11,230'],
  ];

  @override
  Widget build(BuildContext context) {
    return _CardBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('All Categories',
              style: TextStyle(
                  color: AppTheme.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: items.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Row(
                    children: [
                      Text(e[0],
                          style: const TextStyle(
                              color: AppTheme.blue, fontSize: 17)),
                      const SizedBox(width: 8),
                      Expanded(
                          child:
                              Text(e[1], style: const TextStyle(fontSize: 14))),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.blue.withOpacity(.25),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(e[2], style: const TextStyle(fontSize: 11)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

class _FeaturedListings extends StatelessWidget {
  const _FeaturedListings();

  @override
  Widget build(BuildContext context) {
    final data = [
      ['FEATURED', '\$145,000', '3 bd • 2 ba • 1,250 sqft'],
      ['', '\$220,000', '4 bd • 3 ba • 2,100 sqft'],
      ['', '\$89,000', '2 bd • 1 ba • 850 sqft'],
      ['PREMIUM', '\$310,000', '5 bd • 4 ba • 3,200 sqft'],
    ];

    return _CardBox(
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                child: Text('Featured Listings',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Text('View All', style: TextStyle(color: AppTheme.blue)),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Row(
              children: data.map((d) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.panel2,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(10)),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blueGrey.shade700,
                                      Colors.brown.shade800,
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(Icons.house,
                                      size: 54, color: Colors.white70),
                                ),
                              ),
                              if (d[0].isNotEmpty)
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: d[0] == 'PREMIUM'
                                          ? AppTheme.gold
                                          : AppTheme.blue,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(d[0],
                                        style: const TextStyle(fontSize: 10)),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(d[1],
                                  style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 5),
                              Text(d[2],
                                  style: const TextStyle(
                                      color: AppTheme.muted, fontSize: 12)),
                              const SizedBox(height: 8),
                              const Text('📍 Johnstown, PA',
                                  style: TextStyle(
                                      color: AppTheme.muted, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

class _RightPanel extends StatelessWidget {
  const _RightPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(flex: 7, child: _MessagesBox()),
        const SizedBox(height: 12),
        Expanded(flex: 4, child: _ActivityBox()),
      ],
    );
  }
}

class _MessagesBox extends StatelessWidget {
  const _MessagesBox();

  @override
  Widget build(BuildContext context) {
    return _CardBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('PrimeX Messages ●',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 18),
          const Row(
            children: [
              CircleAvatar(
                  radius: 22,
                  backgroundColor: AppTheme.blue,
                  child: Icon(Icons.person)),
              SizedBox(width: 12),
              Expanded(child: Text('Michael Johnson\nOnline')),
              Icon(Icons.call, size: 18),
              SizedBox(width: 12),
              Icon(Icons.videocam, size: 18),
            ],
          ),
          const SizedBox(height: 18),
          Expanded(
            child: ListView(
              children: const [
                _Bubble('Is this property still available?', false),
                _Bubble('Yes, it is still available.', true),
                _Bubble('Can I schedule a viewing?', false),
                _Bubble('Sure! Tomorrow at 2 PM?', true),
              ],
            ),
          ),
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppTheme.panel2,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.border),
            ),
            child: const Row(
              children: [
                Expanded(
                    child: Text('Type a message...',
                        style: TextStyle(color: AppTheme.muted))),
                Icon(Icons.send, color: AppTheme.blue),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final String text;
  final bool me;
  const _Bubble(this.text, this.me);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: me ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 175),
        decoration: BoxDecoration(
          color: me ? AppTheme.blue : AppTheme.panel2,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(text, style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}

class _ActivityBox extends StatelessWidget {
  const _ActivityBox();

  @override
  Widget build(BuildContext context) {
    final items = [
      ['⚡', 'New lead from Miami, FL'],
      ['⚡', 'Property saved in Johnstown'],
      ['✉', 'New message from Sarah K.'],
      ['★', 'Your post is getting views'],
    ];

    return _CardBox(
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                  child:
                      Text('Recent Activity', style: TextStyle(fontSize: 18))),
              Text('View All', style: TextStyle(color: AppTheme.blue)),
            ],
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView(
              children: items.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    children: [
                      CircleAvatar(
                          radius: 14,
                          backgroundColor: AppTheme.blue,
                          child:
                              Text(e[0], style: const TextStyle(fontSize: 11))),
                      const SizedBox(width: 10),
                      Expanded(
                          child:
                              Text(e[1], style: const TextStyle(fontSize: 12))),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return _CardBox(
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 8),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(Icons.home, 'Home', true),
          _NavItem(Icons.search, 'Search', false),
          CircleAvatar(
              radius: 31,
              backgroundColor: AppTheme.blue,
              child: Icon(Icons.add, size: 38)),
          _NavItem(Icons.message, 'Messages', false),
          _NavItem(Icons.person, 'Profile', false),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  const _NavItem(this.icon, this.label, this.active);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: active ? AppTheme.blue : AppTheme.muted),
        Text(label,
            style: TextStyle(
                color: active ? AppTheme.blue : AppTheme.muted, fontSize: 12)),
      ],
    );
  }
}
