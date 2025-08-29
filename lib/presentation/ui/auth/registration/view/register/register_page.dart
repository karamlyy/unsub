import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/ui/auth/registration/provider/register_provider.dart';
import 'package:unsub/presentation/ui/auth/registration/view/register/register_body.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UIColor.transparent,
        surfaceTintColor: UIColor.transparent,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.chevron_back, color: UIColor.primary),
          onPressed: () {
            context.goNamed("onboarding");
          },
        ),
      ),
      body: ChangeNotifierProvider(
        create: (context) => RegisterProvider(),
        child: RegisterBody(),
      ),
    );
  }
}
