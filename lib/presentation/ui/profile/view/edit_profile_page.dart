import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/ui/profile/provider/edit_profile_provider.dart';
import 'package:unsub/presentation/ui/profile/provider/profile_provider.dart';
import 'package:unsub/presentation/ui/profile/view/edit_profile_body.dart';
import 'package:unsub/presentation/widgets/text/primary_text.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UIColor.transparent,
        surfaceTintColor: UIColor.transparent,
        title: PrimaryText("Edit Profile", fontSize: 17),
        leading: TextButton(
          onPressed: () {
            context.goNamed("profile");
          },
          child: IconButton(
            onPressed: () {
              context.goNamed("profile");
            },
            icon: Icon(CupertinoIcons.chevron_back),
            color: UIColor.primary,
          ),
        ),
      ),
      body: ChangeNotifierProvider(
        create: (context) => ProfileProvider(),
        child: EditProfileBody(),
      ),
    );
  }
}
