import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateProvider((ref) {
  return FirebaseAuth.instance.currentUser;
});

final infoTextProvider = StateProvider.autoDispose((ref) {
  return '';
});

final emailProvider = StateProvider.autoDispose((ref) {
  return '';
});

final passwordProvider = StateProvider.autoDispose((ref) {
  return '';
});

final currentIndexProvider = StateProvider.autoDispose((ref) {
  return 0;
});

final pageProvider = StateProvider.autoDispose((ref) {
  return 0;
});

final pointProvider = StreamProvider.autoDispose((ref) {
  final User user = FirebaseAuth.instance.currentUser!;
  return FirebaseFirestore.instance
      .collection('v0')
      .doc('stanp')
      .collection('users')
      .where('uid', isEqualTo: user.uid)
      .snapshots();
});

final newsProvider = StreamProvider.autoDispose((ref) {
  return FirebaseFirestore.instance
      .collection('v0')
      .doc('stanp')
      .collection('news')
      .orderBy('date', descending: true)
      .snapshots();
});

final singleNewsProvider = StateProvider((ref) {
  return '';
});
