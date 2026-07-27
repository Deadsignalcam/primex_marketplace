import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/lead_model.dart';

class LeadModelDataService {
  final _db = FirebaseFirestore.instance;

  Stream<List<LeadModel>> watchLeads() {
    return _db.collection('lead_data').snapshots().map((snap) {
      return snap.docs.map((d) => LeadModel.fromFirestore(d)).toList();
    });
  }

  Future<void> seedLeadData() async {
    final leads = [
      {
        'title': 'Same-Day Warehouse Gig',
        'type': 'Instawork Style Gig',
        'source': 'PrimeX Jobs',
        'thumbnail': '',
        'address': 'Johnstown, PA',
        'lat': 40.3267,
        'lng': -78.9219,
        'phone': '',
        'description':
            'Flexible local gig lead for warehouse, event, delivery, and shift work.',
      },
      {
        'title': 'Kitchen Repair Service Request',
        'type': 'Angi List Style Lead',
        'source': 'PrimeX Services',
        'thumbnail': '',
        'address': 'Pittsburgh, PA',
        'lat': 40.4406,
        'lng': -79.9959,
        'phone': '',
        'description':
            'Customer needs contractor, handyman, cabinet, plumbing, or home repair service.',
      },
      {
        'title': 'Property Field Inspector Needed',
        'type': 'Field Inspection Lead',
        'source': 'PrimeX Lead Data',
        'thumbnail': '',
        'address': 'Altoona, PA',
        'lat': 40.5187,
        'lng': -78.3947,
        'phone': '',
        'description':
            'Exterior/interior inspection, occupancy check, photos, condition report.',
      },
    ];

    for (final lead in leads) {
      await _db.collection('lead_data').add(lead);
    }
  }
}
