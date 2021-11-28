import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../provider.dart';
import './auth.dart';

class QRPage extends StatelessWidget {
  const QRPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return (FirebaseAuth.instance.currentUser == null)
        ? const UnAuthPage()
        : _QRPage();
  }
}

class _QRPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider.state).state;
    final AsyncValue<QuerySnapshot> asyncPointQuery = ref.watch(pointProvider);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          QrImage(
            data: user!.uid,
            version: QrVersions.auto,
            size: 200.0,
          ),
          const SizedBox(height: 15.0),
          asyncPointQuery.when(
            data: (QuerySnapshot query) {
              final Object point = (query == null)
                  ? 0
                  : query.docs.map((document) {
                      return document['point'];
                    });
              return Text(
                '現在のポイント : $point',
                style: const TextStyle(fontSize: 17),
              );
            },
            loading: () {
              return const Text('読込中...');
            },
            error: (e, stackTrace) {
              return Text(e.toString());
            },
          ),
        ],
      ),
    );
  }
}
