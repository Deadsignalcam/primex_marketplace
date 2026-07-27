use strict;
use warnings;

my $file = "lib/screens/dashboard_screen.dart";
open my $fh, "<", $file or die $!;
my $s = do { local $/; <$fh> };
close $fh;

$s =~ s/Widget _postLead\(\) \{.*?\n  Widget _field\(String label\) \{/Widget _postLead() {
    return _box(
      ListView(
        children: [
          const Text(
            'Post New Lead',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),

          _field('Lead Title'),
          _field('Property Address'),
          _field('Price \\/ Lead Cost'),
          _field('Category'),
          _field('Description'),

          const SizedBox(height: 16),

          const Text(
            'Property Photos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            height: 115,
            child: Row(
              children: List.generate(5, (i) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10233D),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: neon.withOpacity(.45)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add_photo_alternate,
                          color: neon,
                          size: 30,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Photo \${i + 1}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Property Video',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Container(
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF10233D),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: gold.withOpacity(.55)),
              boxShadow: [
                BoxShadow(
                  color: gold.withOpacity(.18),
                  blurRadius: 18,
                ),
              ],
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.video_call,
                    color: gold,
                    size: 34,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add 1-minute video',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          Container(
            height: 46,
            decoration: BoxDecoration(
              color: gold,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: gold.withOpacity(.4),
                  blurRadius: 16,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'Publish Lead',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(String label) {/s;

open my $out, ">", $file or die $!;
print $out $s;
close $out;
