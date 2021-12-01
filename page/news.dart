import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider.dart';
// import '../main.dart';
import './auth.dart';

final List<Widget> newsPageList = [
  _NewsPage(),
  const _SingleNewsPage(),
];

class NewsPage extends ConsumerWidget {
  const NewsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return (FirebaseAuth.instance.currentUser == null)
        ? const UnAuthPage()
        : newsPageList[ref.watch(pageProvider.state).state];
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
            return Container(
              margin: const EdgeInsets.only(
                  top: 12.0, left: 20.0, bottom: 0.0, right: 20.0),
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: -15.0,
                    blurRadius: 20.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                  ),
                  child: ListTile(
                    title: Text(
                      document['title'],
                      style: const TextStyle(fontSize: 22.0),
                    ),
                    subtitle: Text(document['date'].toString()),
                    onTap: () async {
                      ref.watch(pageProvider.state).state = 1;
                      ref.watch(singleNewsProvider.state).state = document.id;
                    },
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
      loading: () {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(
                semanticsLabel: 'loading now',
              )
            ],
          ),
        );
      },
      error: (e, StackTrace) {
        return Text(e.toString());
      },
    );
  }
}

class _SingleNewsPage extends ConsumerWidget {
  const _SingleNewsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsID = ref.watch(singleNewsProvider.state).state;

    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('v0')
          .doc('stanp')
          .collection('news')
          .doc(newsID)
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> post =
              snapshot.data!.data() as Map<String, dynamic>;
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 35.0, right: 30.0, bottom: 0.0, left: 30.0),
                child: ListTile(
                  title: Text(
                    post['title'],
                    style: const TextStyle(fontSize: 25.0),
                  ),
                  subtitle: Text(
                    post['date'],
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 20.0, right: 30.0, bottom: 0.0, left: 30.0),
                child: Text(
                  post['content'],
                  style: const TextStyle(fontSize: 20.0),
                ),
              )
            ],
          );
        }
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(
                semanticsLabel: 'loading now',
              )
            ],
          ),
        );
      },
    );
  }
}
