import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/ui/profile/provider/profile_provider.dart';
import 'package:unsub/presentation/ui/profile/view/profile_body.dart';
import 'package:unsub/presentation/widgets/text/primary_text.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UIColor.transparent,
        surfaceTintColor: UIColor.transparent,
        title: PrimaryText("Profile", fontSize: 17),
        actions: [
          TextButton(
            onPressed: () {
              context.goNamed("edit-profile");
            },
            child: PrimaryText(
              "Edit",
              fontSize: 13,
              color: UIColor.primary,
            ),
          ),
        ],
      ),
      body: ChangeNotifierProvider(
        create: (context) => ProfileProvider(),
        child: ProfileBody(),
      ),
    );
  }
}
