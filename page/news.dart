import 'dart:html';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

class _NewsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<QuerySnapshot> asyncNewsQuery = ref.watch(newsProvider);
    return asyncNewsQuery.when(
      data: (QuerySnapshot query) {
        return ListView(
          children: query.docs.map((document) {
            return Card(
              margin: const EdgeInsets.only(
                  top: 12.0, left: 10.0, bottom: 0.0, right: 10.0),
              child: ListTile(
                title: Text(document['title']),
                subtitle: Text(document['date']),
              ),
            );
          }).toList(),
        );
      },
      loading: () {
        return const Text('読込中...');
      },
      error: (e, StackTrace) {
        return Text(e.toString());
      },
    );
    // return ListView(
    //   children: <Widget>[
    //     asyncNewsQuery.when(
    //       data: (QuerySnapshot query) {
    //         query.docs.map(
    //           (document) {
    //             final title = query.docs.map((docuemnt) {
    //               return document['title'];
    //             });
    //             final date = query.docs.map((document) {
    //               return document['date'];
    //             });
    //             return Card(
    //               margin: const EdgeInsets.only(
    //                   top: 12.0, left: 10.0, bottom: 0.0, right: 10.0),
    //               child: ListTile(
    //                 title: Text('$title'),
    //                 subtitle: Text('$date'),
    //               ),
    //             );
    //           },
    //         );
    //       },
    //       loading: () {
    //         return const Text('読込中...');
    //       },
    //       error: (e, stackTrace) {
    //         return Text(e.toString());
    //       },
    //     ),
    //   ],
    // );
  }
}
