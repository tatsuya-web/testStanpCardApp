import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './provider.dart';
import './page/qr.dart';
import './page/news.dart';
import './page/user.dart';
import './page/btmnav.dart';

final List<Map<String, dynamic>> pageMap = [
  {
    'title': const Text('トップ'),
    'page': const QRPage(),
  },
  {
    'title': const Text('お知らせ'),
    'page': const NewsPage(),
  },
  {
    'title': const Text('ユーザー'),
    'page': const UserPage(),
  },
];

final Map<bool, Widget?> navigationBarMap = {
  true: const BottomNav(),
  false: null
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(child: StanpCardApp()),
  );
}

class StanpCardApp extends StatelessWidget {
  const StanpCardApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StanpCardApp',
      theme: ThemeData(
          primaryColor: Colors.black,
          appBarTheme: const AppBarTheme(
              shadowColor: Colors.transparent,
              color: Colors.white,
              titleTextStyle: TextStyle(color: Colors.black87, fontSize: 18.0),
              iconTheme: IconThemeData(color: Colors.black87),
              actionsIconTheme: IconThemeData(color: Colors.black87)),
          scaffoldBackgroundColor: Colors.white,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Colors.black87,
          ),
          buttonTheme: const ButtonThemeData(buttonColor: Colors.grey)),
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: (FirebaseAuth.instance.currentUser != null)
            ? AppBar(
                title: pageMap[ref.watch(currentIndexProvider.state).state]
                    ['title'],
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout_sharp),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return const HomePage();
                        }),
                      );
                    },
                  ),
                ],
              )
            : null,
        body: pageMap[ref.watch(currentIndexProvider.state).state]['page'],
        bottomNavigationBar: (FirebaseAuth.instance.currentUser != null)
            ? navigationBarMap[true]
            : navigationBarMap[false]);
  }
}
