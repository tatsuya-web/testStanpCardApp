import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

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

final pointProvider = StreamProvider.autoDispose((ref) async* {
  final User user = FirebaseAuth.instance.currentUser!;
  yield FirebaseFirestore.instance
      .collection('v0')
      .doc('stanp')
      .collection('users')
      .where('uid', isEqualTo: user.uid)
      .snapshots();
});

final btmnavIndexProvider = StateProvider.autoDispose((ref) {
  return 0;
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ProviderScope(child: StanpCardApp()),
  );
}

class StanpCardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StanpCardApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: (FirebaseAuth.instance.currentUser != null)
            ? AppBar(
                title: PageMap[ref.watch(btmnavIndexProvider.state).state]
                    ['title'],
                actions: [
                  IconButton(
                    icon: Icon(Icons.logout_sharp),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return HomePage();
                        }),
                      );
                    },
                  ),
                ],
              )
            : AppBar(
                title: Text('トップページ'),
              ),
        body: PageMap[ref.watch(btmnavIndexProvider.state).state]['page'],
        bottomNavigationBar: (FirebaseAuth.instance.currentUser != null)
            ? NavigationBarList[true]
            : NavigationBarList[false]);
  }
}

final List<Map<String, dynamic>> PageMap = [
  {
    'title': const Text('トップ'),
    'page': QRPage(),
  },
  {
    'title': const Text('お知らせ'),
    'page': NewsPage(),
  },
  {
    'title': const Text('ユーザー'),
    'page': UserPage(),
  },
];
final Map<bool, Widget?> NavigationBarList = {true: BottomNav(), false: null};

class QRPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (FirebaseAuth.instance.currentUser == null)
        ? UnAuthPage()
        : _QRPage();
  }
}

class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (FirebaseAuth.instance.currentUser == null)
        ? UnAuthPage()
        : _NewsPage();
  }
}

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (FirebaseAuth.instance.currentUser == null)
        ? UnAuthPage()
        : _UserPage();
  }
}

class UnAuthPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                onPressed: () async {
                  await Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) {
                      return LogInPage();
                    }),
                  );
                },
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
                  onPressed: () async {
                    await Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) {
                        return RegisterPage();
                      }),
                    );
                  },
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

class LogInPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final infoText = ref.watch(infoTextProvider.state).state;
    final email = ref.watch(emailProvider.state).state;
    final password = ref.watch(passwordProvider.state).state;
    return Scaffold(
      appBar: AppBar(
        title: Text('ログインページ'),
        actions: [
          IconButton(
            icon: Icon(Icons.close_sharp),
            onPressed: () async {
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) {
                  return HomePage();
                }),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'メールアドレス'),
                onChanged: (String value) {
                  ref.read(emailProvider.state).state = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'パスワード'),
                obscureText: true,
                onChanged: (String value) {
                  ref.read(passwordProvider.state).state = value;
                },
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: Text(infoText),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                child: OutlinedButton(
                  child: Text('ログイン'),
                  onPressed: () async {
                    try {
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final result = await auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      ref.read(userProvider.state).state = result.user;
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return HomePage();
                        }),
                      );
                    } catch (e) {
                      ref.read(infoTextProvider.state).state =
                          "ログインに失敗しました:${e.toString()}";
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final infoText = ref.watch(infoTextProvider.state).state;
    final email = ref.watch(emailProvider.state).state;
    final password = ref.watch(passwordProvider.state).state;
    return Scaffold(
      appBar: AppBar(
        title: Text('ログインページ'),
        actions: [
          IconButton(
            icon: Icon(Icons.close_sharp),
            onPressed: () async {
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) {
                  return HomePage();
                }),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'メールアドレス'),
                onChanged: (String value) {
                  ref.read(emailProvider.state).state = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'パスワード'),
                obscureText: true,
                onChanged: (String value) {
                  ref.read(passwordProvider.state).state = value;
                },
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: Text(infoText),
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('ユーザー登録'),
                  onPressed: () async {
                    try {
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final result = await auth.createUserWithEmailAndPassword(
                          email: email, password: password);
                      ref.read(userProvider.state).state = result.user;
                      await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return HomePage();
                      }));
                    } catch (e) {
                      ref.read(infoTextProvider.state).state =
                          "登録に失敗しました:${e.toString()}";
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
          Text('現在のポイント : ${point}'),
        ],
      ),
    );
  }
}

class _NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Card(
          margin:
              EdgeInsets.only(top: 12.0, left: 10.0, bottom: 0.0, right: 10.0),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Text(
              'ここにショップからのお知らせが入ります。',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        Card(
          margin:
              EdgeInsets.only(top: 12.0, left: 10.0, bottom: 0.0, right: 10.0),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Text(
              'ここにショップからのお知らせが入ります。',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        Card(
          margin:
              EdgeInsets.only(top: 12.0, left: 10.0, bottom: 0.0, right: 10.0),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Text(
              'ここにショップからのお知らせが入ります。',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        Card(
          margin:
              EdgeInsets.only(top: 12.0, left: 10.0, bottom: 0.0, right: 10.0),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Text(
              'ここにショップからのお知らせが入ります。',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        Card(
          margin:
              EdgeInsets.only(top: 12.0, left: 10.0, bottom: 0.0, right: 10.0),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Text(
              'ここにショップからのお知らせが入ります。',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
      ],
    );
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

class BottomNav extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: ref.read(btmnavIndexProvider.state).state,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home_sharp), label: 'トップ'),
        BottomNavigationBarItem(icon: Icon(Icons.info_sharp), label: 'お知らせ'),
        BottomNavigationBarItem(icon: Icon(Icons.people_sharp), label: 'ユーザー'),
      ],
      onTap: (int index) async {
        switch (index) {
          case 0:
            ref.watch(btmnavIndexProvider.state).state = index;
            break;
          case 1:
            ref.watch(btmnavIndexProvider.state).state = index;

            break;
          case 2:
            ref.watch(btmnavIndexProvider.state).state = index;
            break;
        }
      },
    );
  }
}
