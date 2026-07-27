import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> listings() {
    return db.collection('listings').snapshots();
  }

  Future<void> addListing(Map<String, dynamic> data) async {
    await db.collection('listings').add(data);
  }
}
