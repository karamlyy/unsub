import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unsub/presentation/navigation/navigation.dart';
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
        leading: IconButton(
          icon: const Icon(CupertinoIcons.chevron_back, color: UIColor.primary),
          onPressed: () => Navigation.pop(),
        ),
        backgroundColor: UIColor.transparent,
        surfaceTintColor: UIColor.transparent,
        title: PrimaryText("Profile", fontSize: 17),
      ),
      body: ChangeNotifierProvider(
        create: (context) => ProfileProvider(),
        child: ProfileBody(),
      ),
    );
  }
}
