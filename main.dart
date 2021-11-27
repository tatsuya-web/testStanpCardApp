import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (FirebaseAuth.instance.currentUser == null)
        ? UnAuthPage()
        : QRPage();
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

class UnAuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('スタンプカードアプリ'),
      ),
      body: Center(
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
                    await Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (context) {
                      return LogInPage();
                    }));
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
                      }));
                    },
                    child: Text('会員登録'),
                    style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(Size(130.0, 40.0))),
                  )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(),
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
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) {
                  return UnAuthPage();
                }),
              );
            },
            icon: Icon(Icons.close_sharp),
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
                          return QRPage();
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
        title: Text('会員登録ページ'),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) {
                  return UnAuthPage();
                }),
              );
            },
            icon: Icon(Icons.close_sharp),
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
                        return QRPage();
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

class QRPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QRコード'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) {
                  return UnAuthPage();
                }),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text('QRコードがここに入ります。'),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}

class _NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ショップニュース'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) {
                  return UnAuthPage();
                }),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text('ショップからのお知らせ'),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}

class _UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ユーザー情報'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) {
                  return UnAuthPage();
                }),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text('ユーザー情報がここに入ります。'),
      ),
      bottomNavigationBar: BottomNav(),
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
        BottomNavigationBarItem(icon: Icon(Icons.home_sharp), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.info_sharp), label: 'News'),
        BottomNavigationBarItem(icon: Icon(Icons.people_sharp), label: 'User'),
      ],
      onTap: (int index) async {
        switch (index) {
          case 0:
            ref.watch(btmnavIndexProvider.state).state = index;
            await Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              return HomePage();
            }));
            break;
          case 1:
            ref.watch(btmnavIndexProvider.state).state = index;
            await Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              return NewsPage();
            }));

            break;
          case 2:
            ref.watch(btmnavIndexProvider.state).state = index;
            await Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              return UserPage();
            }));
            break;
        }
      },
    );
  }
}
