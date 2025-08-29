import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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
            onPressed: () => context.goNamed('add-subscription'),
            icon: Icon(Icons.add_circle, color: UIColor.primary,),
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
