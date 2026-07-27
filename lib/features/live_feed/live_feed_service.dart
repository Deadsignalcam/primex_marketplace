import 'package:cloud_firestore/cloud_firestore.dart';

class LiveFeedService {
  static final feed = FirebaseFirestore.instance.collection('live_feed');

  static Future<void> updatePost({
    required String postId,
    required String title,
    required String description,
  }) async {
    await feed.doc(postId).update({
      'title': title,
      'description': description,
      'updatedAt': Timestamp.now(),
    });
  }

  static Future<void> deletePost(String postId) async {
    await feed.doc(postId).delete();
  }
}
