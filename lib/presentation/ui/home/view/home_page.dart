import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/ui/home/provider/home_provider.dart';
import 'package:unsub/presentation/ui/home/provider/bottom_nav_provider.dart';
import 'package:unsub/presentation/ui/home/view/home_body.dart';
import 'package:unsub/presentation/ui/instructions/view/instructions_body.dart';
import 'package:unsub/presentation/ui/instructions/provider/instructions_provider.dart';
import 'package:unsub/presentation/ui/profile/view/profile_body.dart';
import 'package:unsub/presentation/ui/profile/provider/profile_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BottomNavProvider(),
      child: Consumer<BottomNavProvider>(
        builder: (context, nav, _) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: UIColor.transparent,
              surfaceTintColor: UIColor.transparent,
              actions: [
                if (nav.currentIndex == 0)
                  IconButton(
                    onPressed: () => context.goNamed('add-subscription'),
                    icon: Icon(Icons.add_circle, color: UIColor.primary,),
                  ),
              ],
            ),
            body: IndexedStack(
              index: nav.currentIndex,
              children: [
                ChangeNotifierProvider(
                  create: (context) => HomeProvider()..loadMock(),
                  child: HomeBody(),
                ),
                ChangeNotifierProvider(
                  create: (context) => InstructionsProvider(),
                  child: InstructionsBody(),
                ),
                ChangeNotifierProvider(
                  create: (context) => ProfileProvider(),
                  child: ProfileBody(),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: nav.currentIndex,
              backgroundColor: Colors.black,
              selectedItemColor: UIColor.primary,
              unselectedItemColor: Colors.white70,
              onTap: nav.setIndex,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: 'Instructions'),
                BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
              ],
            ),
          );
        },
      ),
    );
  }
}
