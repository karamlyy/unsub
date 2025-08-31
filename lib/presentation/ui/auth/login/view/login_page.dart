import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/ui/auth/login/provider/login_provider.dart';
import 'package:unsub/presentation/ui/auth/login/view/login_body.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: ChangeNotifierProvider(
        create: (_) => LoginProvider(),
        child: const LoginBody(),
      ),
    );
  }
}