import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/cubit/auth_cubit.dart';
import '../../../../core/theme/theme_helper.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRegisterPressed(BuildContext context) {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ad, email və şifrə boş ola bilməz')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Şifrə ən azı 6 simvol olmalıdır')),
      );
      return;
    }

    context.read<AuthCubit>().register(name, email, password);
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF22C55E);
    final labelColor = ThemeHelper.subtitleColor(context);
    final titleColor = ThemeHelper.titleColor(context);
    final subtitleColor = ThemeHelper.subtitleColor(context);
    final surface = Theme.of(context).colorScheme.surface;
    final borderColor = ThemeHelper.borderColor(context);
    final isDark = ThemeHelper.isDark(context);

    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (prev, curr) => curr is AuthFailure,
      listener: (context, state) {
        if (state is AuthFailure) {
          final msg = state.message.replaceFirst('Exception: ', '');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(msg)));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: isDark ? const Color(0x66000000) : const Color(0x1A000000),
              blurRadius: 32,
              spreadRadius: -8,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header
            Row(
              children: [
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withOpacity(0.5),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'U',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'UnSub',
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Yeni hesab yarat və abunəliklərini tək yerdən idarə et.',
              style: TextStyle(color: subtitleColor, fontSize: 13),
            ),
            const SizedBox(height: 24),

            Text(
              'Ad',
              style: TextStyle(
                color: labelColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Karam Afandi'),
            ),
            const SizedBox(height: 14),

            Text(
              'Email',
              style: TextStyle(
                color: labelColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(hintText: 'user@example.com'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),

            Text(
              'Şifrə',
              style: TextStyle(
                color: labelColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(hintText: '••••••••'),
              obscureText: true,
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Container(
                  height: 6,
                  width: 6,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Qeydiyyatla şərtləri və məxfilik siyasətini qəbul edirsən.',
                    style: TextStyle(color: subtitleColor, fontSize: 11),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                final isLoading = state is AuthLoading;
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () => _onRegisterPressed(context),
                    child: isLoading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.black,
                              ),
                            ),
                          )
                        : const Text('Qeydiyyatdan keç'),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // login-ə geri
                },
                child: Text(
                  'Artıq hesabın var? Daxil ol',
                  style: TextStyle(color: labelColor, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
