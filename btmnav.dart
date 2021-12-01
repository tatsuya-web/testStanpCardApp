import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'provider.dart';

class BottomNav extends ConsumerWidget {
  const BottomNav({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: ref.read(currentIndexProvider.state).state,
      selectedItemColor: Colors.black87,
      unselectedItemColor: Colors.grey,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_sharp),
          label: 'Top',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.info_sharp), label: 'Info'),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_sharp), label: 'User'),
      ],
      onTap: (int index) async {
        switch (index) {
          case 0:
            ref.watch(pageProvider.state).state = 0;
            ref.watch(currentIndexProvider.state).state = index;
            break;
          case 1:
            ref.watch(pageProvider.state).state = 0;
            ref.watch(currentIndexProvider.state).state = index;
            break;
          case 2:
            ref.watch(pageProvider.state).state = 0;
            ref.watch(currentIndexProvider.state).state = index;
            break;
        }
      },
    );
  }
}
