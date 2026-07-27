use strict;
use warnings;
my $file = "lib/screens/dashboard_screen.dart";
open my $fh, "<", $file or die $!;
my $s = do { local $/; <$fh> };
close $fh;

$s =~ s/Widget _tabBody\(String title\) \{.*?\n  \}/Widget _tabBody(String title) {
    switch (title) {
      case 'Map':
        return _mapPanel();

      case 'Categories':
        return _glass(GridView.count(
          crossAxisCount: 4,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 2.2,
          children: ['Real Estate','Housing','Rentals','Foreclosures','For Sale','Vehicles','Jobs','Services','Community','Events','Pets']
              .map((e) => Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF10233D),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: neon.withOpacity(.35)),
                    ),
                    child: Center(
                      child: Text(e, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ))
              .toList(),
        ));

      case 'Leads':
        return _glass(ListView(
          children: ['Foreclosure Lead - \$9.99', 'Investor Subscription - \$49\\/mo', 'Cash Buyer Lead', 'Rental Lead']
              .map((e) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10233D),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: neon.withOpacity(.35)),
                    ),
                    child: Text(e, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ))
              .toList(),
        ));

      case 'Messages':
        return _messagesPanel();

      case 'Saved':
        return _glass(GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          children: List.generate(6, (i) => Container(
            decoration: BoxDecoration(
              color: const Color(0xFF10233D),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: neon.withOpacity(.35)),
            ),
            child: const Center(
              child: Text('\\$145,000\\nSaved Property', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          )),
        ));

      case 'Profile':
        return _glass(const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(radius: 42, backgroundColor: neon, child: Icon(Icons.person, color: Colors.white, size: 44)),
            SizedBox(height: 20),
            Text('PrimeX User Profile', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text('Plan: Investor', style: TextStyle(color: gold, fontSize: 20)),
            Text('Location: Johnstown, PA', style: TextStyle(color: Colors.white70, fontSize: 18)),
            Text('Saved Listings: 6', style: TextStyle(color: Colors.white70, fontSize: 18)),
            Text('Active Leads: 4', style: TextStyle(color: Colors.white70, fontSize: 18)),
          ],
        ));

      case 'Settings':
        return _glass(ListView(
          children: const [
            ListTile(title: Text('Notifications', style: TextStyle(color: Colors.white)), trailing: Icon(Icons.toggle_on, color: neon)),
            ListTile(title: Text('Dark Neon Mode', style: TextStyle(color: Colors.white)), trailing: Icon(Icons.toggle_on, color: neon)),
            ListTile(title: Text('Billing & Subscription', style: TextStyle(color: Colors.white)), trailing: Icon(Icons.chevron_right, color: Colors.white)),
            ListTile(title: Text('Privacy & Safety', style: TextStyle(color: Colors.white)), trailing: Icon(Icons.chevron_right, color: Colors.white)),
          ],
        ));

      default:
        return _mapPanel();
    }
  }/s;

open my $out, ">", $file or die $!;
print $out $s;
close $out;
