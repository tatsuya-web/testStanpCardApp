import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider.dart';

class BottomNav extends ConsumerWidget {
  const BottomNav({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: ref.read(currentIndexProvider.state).state,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home_sharp), label: 'トップ'),
        BottomNavigationBarItem(icon: Icon(Icons.info_sharp), label: 'お知らせ'),
        BottomNavigationBarItem(icon: Icon(Icons.people_sharp), label: 'ユーザー'),
      ],
      onTap: (int index) async {
        switch (index) {
          case 0:
            ref.watch(currentIndexProvider.state).state = index;
            break;
          case 1:
            ref.watch(currentIndexProvider.state).state = index;
            break;
          case 2:
            ref.watch(currentIndexProvider.state).state = index;
            break;
        }
      },
    );
  }
}
