import 'package:flutter/material.dart';

class PrimeXSignature extends StatelessWidget {
  const PrimeXSignature({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF050816),
            Color(0xFF07142B),
            Color(0xFF02040B),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF19D7FF).withOpacity(.65),
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D9FF).withOpacity(.18),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          /// PRIME X
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Prime',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    letterSpacing: -.5,
                    shadows: [
                      Shadow(
                        color: Colors.white.withOpacity(.55),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
                TextSpan(
                  text: 'X',
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF27E8FF),
                    shadows: [
                      Shadow(
                        color: const Color(0xFF27E8FF).withOpacity(.95),
                        blurRadius: 38,
                      ),
                      Shadow(
                        color: const Color(0xFF008CFF).withOpacity(.85),
                        blurRadius: 65,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'M A R K E T P L A C E',
            style: TextStyle(
              color: Colors.white.withOpacity(.92),
              letterSpacing: 9,
              fontSize: 13,
              fontWeight: FontWeight.w300,
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1.2,
                  color: const Color(0xFF17D7FF).withOpacity(.7),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFF1FE5FF),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF16E0FF).withOpacity(.45),
                      blurRadius: 24,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Text(
                  'SELL • BUY • CONNECT • GROW',
                  style: TextStyle(
                    color: Color(0xFF2AF0FF),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    letterSpacing: 2.2,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 1.2,
                  color: const Color(0xFF17D7FF).withOpacity(.7),
                ),
              ),
            ],
          ),

          const SizedBox(height: 26),

          /// SYNTAX PHANTOM WOMAN
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF0EF0FF).withOpacity(.55),
                        const Color(0xFF040B17),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 25,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00E7FF).withOpacity(.9),
                          blurRadius: 40,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.shield_moon,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: 240,
                    height: 170,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          const Color(0xFF00131F).withOpacity(.85),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 34,
                  child: Column(
                    children: [
                      Text(
                        'SYNTAX PHANTOM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              color: const Color(0xFF1EE8FF).withOpacity(.9),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '@ 2 0 2 6',
                        style: TextStyle(
                          color: const Color(0xFF1EE8FF),
                          fontSize: 15,
                          letterSpacing: 7,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: 240,
                        height: 1,
                        color: const Color(0xFF1EE8FF).withOpacity(.45),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'P H I L I P P I A N S   I V : 1 3',
                        style: TextStyle(
                          color: const Color(0xFF39EAFF),
                          fontSize: 13,
                          letterSpacing: 5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '" I CAN DO ALL THINGS\\nTHROUGH CHRIST WHO STRENGTHENS ME. "',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(.9),
                          height: 1.5,
                          fontSize: 11,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
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
