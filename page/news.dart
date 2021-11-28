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
      children: [
        Card(
          margin: const EdgeInsets.only(
              top: 12.0, left: 10.0, bottom: 0.0, right: 10.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: const Text(
              'ここにショップからのお知らせが入ります。',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.only(
              top: 12.0, left: 10.0, bottom: 0.0, right: 10.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: const Text(
              'ここにショップからのお知らせが入ります。',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.only(
              top: 12.0, left: 10.0, bottom: 0.0, right: 10.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: const Text(
              'ここにショップからのお知らせが入ります。',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.only(
              top: 12.0, left: 10.0, bottom: 0.0, right: 10.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: const Text(
              'ここにショップからのお知らせが入ります。',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.only(
              top: 12.0, left: 10.0, bottom: 0.0, right: 10.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: const Text(
              'ここにショップからのお知らせが入ります。',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}
