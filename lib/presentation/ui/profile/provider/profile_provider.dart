import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class ProfileMenuItem {
  final IconData icon;
  final String title;
  final String? routeName;
  final void Function(BuildContext)? onTap;

  const ProfileMenuItem({
    required this.icon,
    required this.title,
    this.routeName,
    this.onTap,
  });
}

class ProfileProvider extends ChangeNotifier {
  final List<ProfileMenuItem> menu = [
    ProfileMenuItem(icon: CupertinoIcons.info_circle, title: 'About the app', routeName: 'about-app',),
    ProfileMenuItem(icon: CupertinoIcons.question_circle, title: 'Frequent questions', routeName: 'faq',),
    ProfileMenuItem(icon: CupertinoIcons.doc, title: 'Terms of the agreement', routeName: 'terms',),
    ProfileMenuItem(icon: CupertinoIcons.checkmark_shield, title: 'Privacy Policy', routeName: 'privacy',),
  ];

  void handleTap(BuildContext context, int index) {
    final item = menu[index];
    if (item.routeName != null) {
      context.pushNamed(item.routeName!);
    } else {
      item.onTap?.call(context);
    }
  }

  String username = "karam";

  void updateUsername(String value) {
    username = value;
    notifyListeners();
  }

  Future<void> saveProfile() async {
    await Future.delayed(const Duration(milliseconds: 800));
    print("Profile saved: Username - $username");
  }

  void logout() {
    print("User logged out");
  }
}