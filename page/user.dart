import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider.dart';
import './auth.dart';

final List<Widget> userPageList = [
  _UserPage(),
];

class UserPage extends ConsumerWidget {
  const UserPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return (FirebaseAuth.instance.currentUser == null)
        ? const UnAuthPage()
        : userPageList[ref.watch(userPageProvider.state).state];
  }
}

class _UserPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider.state).state;
    return Center(
      child: Text('ユーザー情報 : ${user!.email}'),
    );
  }
}
