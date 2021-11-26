import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(StanpCardApp());
}

class StanpCardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'StanpCardApp',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('スタンプカードアプリ'),
      ),
      body: UnAuthPage(),
      bottomNavigationBar: BottomNav(),
    );
  }
}

class UnAuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Text('ログインまたは会員登録をしてください。'),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {},
                child: Text('ログイン'),
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(130, 40.0))),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                padding: EdgeInsets.all(8),
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('会員登録'),
                  style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(Size(130.0, 40.0))),
                )),
          ],
        ),
      ),
    );
  }
}

class BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home_sharp), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.info_sharp), label: 'Info'),
        BottomNavigationBarItem(icon: Icon(Icons.people_sharp), label: 'User'),
      ],
      onTap: (int index) {},
    );
  }
}
