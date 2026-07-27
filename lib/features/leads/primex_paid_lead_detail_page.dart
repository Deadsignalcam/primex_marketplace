import 'package:flutter/material.dart';

class PrimeXPaidLeadDetailPage extends StatelessWidget {
  const PrimeXPaidLeadDetailPage({super.key, required this.lead});
  final Map lead;

  @override
  Widget build(BuildContext context) {
    final title = '${lead['title'] ?? 'PrimeX Pro Property Lead'}';
    final address =
        '${lead['fullAddress'] ?? lead['address'] ?? 'Full address'}';
    final type = '${lead['leadType'] ?? lead['type'] ?? 'Market Lead'}';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Unlocked Pro Lead'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.25,
            colors: [Color(0xFF092B46), Color(0xFF020617), Colors.black],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            box(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(spacing: 8, runSpacing: 8, children: [
                  chip(Icons.lock_open, 'PRO UNLOCKED', Colors.greenAccent),
                  chip(Icons.photo_library, '30 PHOTOS', Colors.cyanAccent),
                  chip(Icons.video_library, '5 VIDEOS', Colors.purpleAccent),
                ]),
                const SizedBox(height: 16),
                Container(
                  height: 210,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: Colors.cyanAccent.withOpacity(.35)),
                    color: Colors.white.withOpacity(.05),
                  ),
                  child: const Center(
                      child: Icon(Icons.house,
                          color: Colors.cyanAccent, size: 90)),
                ),
                const SizedBox(height: 16),
                Text(type.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.amber, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(address,
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 16)),
              ],
            )),
            box(Column(children: [
              row(
                  'Opening Bid',
                  '${lead['openingBid'] ?? lead['price'] ?? 'Not listed'}',
                  Icons.attach_money),
              row(
                  'Auction Date',
                  '${lead['auctionDate'] ?? 'Add auction date'}',
                  Icons.calendar_month),
              row(
                  'Parcel Number',
                  '${lead['parcelNumber'] ?? lead['parcel'] ?? 'Add parcel'}',
                  Icons.numbers),
              row('County', '${lead['county'] ?? ''}', Icons.location_city),
              row('State', '${lead['state'] ?? ''}', Icons.map),
              row('Map Pin', '${lead['lat'] ?? ''}, ${lead['lng'] ?? ''}',
                  Icons.location_on),
            ])),
            box(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              section('Investor Tools'),
              row('Estimated ARV', '${lead['arv'] ?? 'Add ARV'}',
                  Icons.trending_up),
              row('Rehab Cost', '${lead['rehabCost'] ?? 'Add rehab'}',
                  Icons.construction),
              row('ROI Estimate', '${lead['roi'] ?? 'Add ROI'}',
                  Icons.show_chart),
              row('Investment Score', '${lead['investmentScore'] ?? 'Pending'}',
                  Icons.star),
            ])),
            box(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              section('Photos & Videos'),
              const SizedBox(height: 10),
              Row(children: [
                media(Icons.photo_library, 'Photo Gallery', 'Max 30'),
                const SizedBox(width: 10),
                media(Icons.video_library, 'Video Gallery', 'Max 5'),
              ]),
            ])),
            box(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              section('Buyer Actions'),
              const SizedBox(height: 10),
              action(Icons.verified_user, 'Upload Proof Of Funds'),
              action(Icons.favorite, 'Save Lead'),
              action(Icons.remove_red_eye, 'Watch Lead'),
              action(Icons.handshake, 'Make Offer'),
            ])),
            const Text(
              'PrimeX Disclaimer: Verify all auction, lien, tax, and property information with official county records before bidding.',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget box(Widget child) => Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.58),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.cyanAccent.withOpacity(.25)),
        ),
        child: child,
      );

  Widget chip(IconData icon, String text, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: color.withOpacity(.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(.55)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 7),
          Text(text,
              style: TextStyle(color: color, fontWeight: FontWeight.w900)),
        ]),
      );

  Widget section(String t) => Text(t,
      style: const TextStyle(
          color: Colors.cyanAccent, fontSize: 18, fontWeight: FontWeight.w900));

  Widget row(String a, String b, IconData icon) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(children: [
          Icon(icon, color: Colors.cyanAccent, size: 20),
          const SizedBox(width: 10),
          Expanded(
              child: Text(a, style: const TextStyle(color: Colors.white70))),
          Flexible(
              child: Text(b,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w800))),
        ]),
      );

  Widget media(IconData icon, String title, String sub) => Expanded(
        child: Container(
          height: 105,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, color: Colors.cyanAccent, size: 34),
            const SizedBox(height: 6),
            Text(title,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            Text(sub, style: const TextStyle(color: Colors.white54)),
          ]),
        ),
      );

  Widget action(IconData icon, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: OutlinedButton.icon(
          onPressed: () {},
          icon: Icon(icon),
          label: Text(text),
        ),
      );
}
