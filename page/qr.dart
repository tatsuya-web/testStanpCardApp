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
    final point =
        (ref.read(pointProvider) == null) ? ref.read(pointProvider) : 0;
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
          Text(
            '現在のポイント : $point',
            style: const TextStyle(fontSize: 17),
          ),
        ],
      ),
    );
  }
}
