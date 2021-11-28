import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider.dart';
import './auth.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return (FirebaseAuth.instance.currentUser == null)
        ? const UnAuthPage()
        : _NewsPage();
  }
}

class _NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        Card(
          margin:
              EdgeInsets.only(top: 12.0, left: 10.0, bottom: 0.0, right: 10.0),
          child: ListTile(
            title: Text('ここにショップからのお知らせが入ります。'),
            subtitle: Text('2021-11-28'),
          ),
        ),
        Card(
          margin:
              EdgeInsets.only(top: 12.0, left: 10.0, bottom: 0.0, right: 10.0),
          child: ListTile(
            title: Text('ここにショップからのお知らせが入ります。'),
            subtitle: Text('2021-11-28'),
          ),
        ),
        Card(
          margin:
              EdgeInsets.only(top: 12.0, left: 10.0, bottom: 0.0, right: 10.0),
          child: ListTile(
            title: Text('ここにショップからのお知らせが入ります。'),
            subtitle: Text('2021-11-28'),
          ),
        ),
      ],
    );
  }
}
