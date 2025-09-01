import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:unsub/presentation/navigation/app_router.dart';
import 'package:unsub/presentation/navigation/navigation.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/ui/home/provider/home_provider.dart';
import 'package:unsub/presentation/ui/home/view/home_body.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UIColor.transparent,
        surfaceTintColor: UIColor.transparent,
        actions: [
          IconButton(
            onPressed: () => Navigation.push(Routes.instructions),
            icon: Icon(Icons.menu_book_outlined, color: UIColor.primary),
          ),
          IconButton(
            onPressed: () => Navigation.push(Routes.profile),
            icon: Icon(Icons.person_outline, color: UIColor.primary),
          ),

        ],
      ),
      body: ChangeNotifierProvider(
        create: (context) => HomeProvider()..loadMock(),
        child: HomeBody(),
      ),
    );
  }
}
