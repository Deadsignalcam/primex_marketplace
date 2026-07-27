import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DealRoomPage extends StatefulWidget {
  const DealRoomPage({super.key});

  @override
  State<DealRoomPage> createState() => _DealRoomPageState();
}

class _DealRoomPageState extends State<DealRoomPage> {
  String filter = 'All';

  final filters = const [
    'All',
    'Offers',
    'Comps',
    'Title Companies',
    'Proof of Funds',
    'Contracts',
    'Closed Sales',
    'Revenue',
  ];

  final start = const CameraPosition(
    target: LatLng(39.8283, -98.5795),
    zoom: 4,
  );

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('PrimeX Deal Room'),
      ),
      body: user == null
          ? const Center(
              child:
                  Text('Login first.', style: TextStyle(color: Colors.white)))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: DropdownButtonFormField<String>(
                    initialValue: filter,
                    dropdownColor: Colors.black,
                    style: const TextStyle(color: Colors.white),
                    decoration: deco('Deal Room Filter'),
                    items: filters
                        .map((x) => DropdownMenuItem(value: x, child: Text(x)))
                        .toList(),
                    onChanged: (v) => setState(() => filter = v ?? filter),
                  ),
                ),
                SizedBox(
                  height: 280,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('primex_leads')
                        .snapshots(),
                    builder: (context, snap) {
                      if (!snap.hasData)
                        return const Center(child: CircularProgressIndicator());

                      final markers = <Marker>{};

                      for (final d in snap.data!.docs) {
                        final x = d.data() as Map<String, dynamic>;
                        final lat = double.tryParse('${x['lat'] ?? ''}');
                        final lng = double.tryParse('${x['lng'] ?? ''}');
                        if (lat == null || lng == null) continue;

                        markers.add(
                          Marker(
                            markerId: MarkerId(d.id),
                            position: LatLng(lat, lng),
                            infoWindow: InfoWindow(
                              title: '${x['type'] ?? 'Lead'}',
                              snippet: '${x['address'] ?? ''}',
                            ),
                          ),
                        );
                      }

                      return GoogleMap(
                        initialCameraPosition: start,
                        markers: markers,
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                      );
                    },
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('primex_leads')
                        .snapshots(),
                    builder: (context, snap) {
                      if (!snap.hasData)
                        return const Center(child: CircularProgressIndicator());

                      final docs = snap.data!.docs;

                      return ListView(
                        padding: const EdgeInsets.all(12),
                        children: docs.map((d) {
                          final x = d.data() as Map<String, dynamic>;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: panel(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '${x['type'] ?? 'Lead'} • ${x['title'] ?? ''}',
                                    style: const TextStyle(
                                        color: Color(0xFF00E5FF),
                                        fontWeight: FontWeight.bold)),
                                Text('Address: ${x['address'] ?? ''}',
                                    style:
                                        const TextStyle(color: Colors.white)),
                                Text(
                                    'Offers: ${x['offerStatus'] ?? 'None yet'}',
                                    style: const TextStyle(
                                        color: Color(0xFFFFD700))),
                                Text('Buyer/Seller: ${x['buyerName'] ?? ''}',
                                    style:
                                        const TextStyle(color: Colors.white70)),
                                Text(
                                    'Proof of Funds: ${x['proofOfFundsUrl'] ?? ''}',
                                    style:
                                        const TextStyle(color: Colors.white70)),
                                Text('Comps: ${x['comps'] ?? ''}',
                                    style:
                                        const TextStyle(color: Colors.white70)),
                                Text(
                                    'Title Company: ${x['titleCompanyLocation'] ?? x['titleCompany'] ?? ''}',
                                    style:
                                        const TextStyle(color: Colors.white70)),
                                Text('Revenue: ${x['revenue'] ?? ''}',
                                    style: const TextStyle(
                                        color: Color(0xFF00E5FF))),
                                const SizedBox(height: 8),
                                ElevatedButton.icon(
                                  onPressed: () => showAgreement(context, x),
                                  icon: const Icon(Icons.description),
                                  label: const Text(
                                      'View Offer / Title Agreement Draft'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFD700),
                                    foregroundColor: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void showAgreement(BuildContext context, Map<String, dynamic> x) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF101522),
        title: const Text('PrimeX Agreement Draft',
            style: TextStyle(color: Color(0xFF00E5FF))),
        content: SingleChildScrollView(
          child: Text(
            '''
PRIMEX MARKETPLACE OFFER / TITLE COMPANY AGREEMENT DRAFT

Property:
${x['address'] ?? ''}

Buyer / Investor:
${x['buyerName'] ?? ''}

Offer Amount:
${x['offerAmount'] ?? ''}

Proof of Funds:
${x['proofOfFundsUrl'] ?? ''}

Title Company / Closing Office:
${x['titleCompanyLocation'] ?? x['titleCompany'] ?? ''}

Comps / ARV:
${x['comps'] ?? ''}
ARV: ${x['arv'] ?? ''}

Sale Status:
${x['saleStatus'] ?? ''}

Closing Date:
${x['closingDate'] ?? ''}

Notes:
${x['notes'] ?? ''}

This is a PrimeX draft for organization and communication only. Parties should have a licensed attorney/title company review all final documents before signing or closing.
''',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('Close', style: TextStyle(color: Color(0xFFFFD700))),
          ),
        ],
      ),
    );
  }

  InputDecoration deco(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF101522),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      );

  BoxDecoration panel() => BoxDecoration(
        color: const Color(0xFF101522),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF00E5FF)),
      );
}
