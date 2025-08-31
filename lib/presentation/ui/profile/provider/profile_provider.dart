import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:unsub/app/view/di.dart';
import 'package:unsub/data/repository/auth_repository.dart';

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
  final AuthRepository _authRepository = locator.get<AuthRepository>();
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

  String username = "";
  bool isLoading = true;
  String? errorMessage;

  bool _isDisposed = false;

  ProfileProvider() {
    _loadMe();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (_isDisposed) return;
    notifyListeners();
  }

  Future<void> _loadMe() async {
    isLoading = true;
    _safeNotify();
    final result = await _authRepository.me();
    result.fold((l) {
      errorMessage = l.error.message;
      isLoading = false;
      _safeNotify();
    }, (r) {
      username = r.username;
      isLoading = false;
      _safeNotify();
    });
  }

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