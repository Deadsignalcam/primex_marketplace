import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/primex_job_opportunity.dart';

class PrimeXJobsService {
  PrimeXJobsService._();

  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static CollectionReference<Map<String, dynamic>> get opportunities =>
      _db.collection('jobs_services');

  static Stream<List<PrimeXJobOpportunity>> watchActiveOpportunities() {
    return opportunities
        .orderBy('createdAt', descending: true)
        .limit(250)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(PrimeXJobOpportunity.fromDocument)
              .where(
                (item) =>
                    item.status == 'active' ||
                    item.status == 'approved' ||
                    item.status == 'published',
              )
              .toList(),
        );
  }

  static Future<String> createOpportunity(
    PrimeXJobOpportunity opportunity,
  ) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw StateError('Sign in before posting an opportunity.');
    }

    final reference = opportunities.doc();

    await reference.set(
      <String, dynamic>{
        ...opportunity.toFirestore(),
        'ownerId': user.uid,
        'userId': user.uid,
        'ownerEmail': user.email ?? '',
        'id': reference.id,

        // Change to "pending" later when admin approval is required.
        'status': 'active',
      },
    );

    return reference.id;
  }

  static Future<void> recordView(String opportunityId) async {
    if (opportunityId.isEmpty) return;

    await opportunities.doc(opportunityId).set(
      <String, dynamic>{
        'viewCount': FieldValue.increment(1),
        'views': FieldValue.increment(1),
        'lastViewedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  static Future<void> saveOpportunity(String opportunityId) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw StateError('Sign in before saving an opportunity.');
    }

    final savedReference = _db
        .collection('users')
        .doc(user.uid)
        .collection('saved_jobs_services')
        .doc(opportunityId);

    await _db.runTransaction((transaction) async {
      final savedSnapshot = await transaction.get(savedReference);

      if (savedSnapshot.exists) {
        transaction.delete(savedReference);
        transaction.set(
          opportunities.doc(opportunityId),
          <String, dynamic>{
            'saveCount': FieldValue.increment(-1),
            'saves': FieldValue.increment(-1),
          },
          SetOptions(merge: true),
        );
      } else {
        transaction.set(savedReference, <String, dynamic>{
          'opportunityId': opportunityId,
          'savedAt': FieldValue.serverTimestamp(),
        });

        transaction.set(
          opportunities.doc(opportunityId),
          <String, dynamic>{
            'saveCount': FieldValue.increment(1),
            'saves': FieldValue.increment(1),
          },
          SetOptions(merge: true),
        );
      }
    });
  }

  static Future<bool> isSaved(String opportunityId) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final snapshot = await _db
        .collection('users')
        .doc(user.uid)
        .collection('saved_jobs_services')
        .doc(opportunityId)
        .get();

    return snapshot.exists;
  }

  static Future<void> apply({
    required PrimeXJobOpportunity opportunity,
    String note = '',
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw StateError('Sign in before applying.');
    }

    final applicationReference = opportunities
        .doc(opportunity.id)
        .collection('applications')
        .doc(user.uid);

    await _db.runTransaction((transaction) async {
      final existing = await transaction.get(applicationReference);

      transaction.set(
        applicationReference,
        <String, dynamic>{
          'applicantId': user.uid,
          'applicantEmail': user.email ?? '',
          'applicantName': user.displayName ?? '',
          'opportunityId': opportunity.id,
          'opportunityTitle': opportunity.title,
          'companyName': opportunity.companyName,
          'employerId': opportunity.ownerId,
          'note': note.trim(),
          'status': 'submitted',
          'updatedAt': FieldValue.serverTimestamp(),
          if (!existing.exists) 'createdAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      if (!existing.exists) {
        transaction.set(
          opportunities.doc(opportunity.id),
          <String, dynamic>{
            'applicantCount': FieldValue.increment(1),
          },
          SetOptions(merge: true),
        );
      }
    });

    if (opportunity.ownerId.isNotEmpty && opportunity.ownerId != user.uid) {
      await _db
          .collection('users')
          .doc(opportunity.ownerId)
          .collection('notifications')
          .add(<String, dynamic>{
        'type': 'job_application',
        'title': 'New application',
        'message':
            '${user.displayName ?? 'A PrimeX member'} applied for ${opportunity.title}.',
        'opportunityId': opportunity.id,
        'applicantId': user.uid,
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
