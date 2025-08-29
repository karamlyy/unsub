import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unsub/presentation/shared/color.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    int currentIndex = 0;
    if (location.startsWith('/profile')) {
      currentIndex = 2;
    } else if (location.startsWith('/intructions')) {
      currentIndex = 1;
    }
    else {
      currentIndex = 0;
    }

    return BottomNavigationBar(
      currentIndex: currentIndex,
      backgroundColor: Colors.black,
      selectedItemColor: UIColor.primary,
      unselectedItemColor: UIColor.textDisabled,
      items: [
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.home),
          activeIcon: Icon(CupertinoIcons.house_fill),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.doc_text),
          activeIcon: Icon(CupertinoIcons.doc_text_fill),
          label: 'Instructions',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined),
          activeIcon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
            context.go('/intructions');
            break;
          case 2:
            context.go('/profile');
            break;
        }
      },
    );
  }
}
