import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/profile_repository.dart';
import '../../presentation/cubit/profile_cubit.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/theme/theme_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<ProfileRepository>();

    return BlocProvider(
      create: (_) => ProfileCubit(profileRepository: repo)..loadProfile(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    const titleColor = Color(0xFFF9FAFB);
    const subtitleColor = Color(0xFF9CA3AF);
    const surface = Color(0xFF020617);
    const border = Color(0xFF111827);
    const accent = Color(0xFF22C55E);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading || state is ProfileInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProfileFailure) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Color(0xFFF97373),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Profil yüklənmədi',
                          style: TextStyle(
                            color: titleColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          state.message,
                          style: const TextStyle(
                            color: subtitleColor,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is! ProfileLoaded) {
                return const SizedBox.shrink();
              }

              final user = state.user;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: surface.withOpacity(0.96),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: border),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x66000000),
                          blurRadius: 24,
                          spreadRadius: -6,
                          offset: Offset(0, 18),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 52,
                          width: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: accent.withOpacity(0.45),
                                blurRadius: 24,
                                spreadRadius: 2,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _initials(user.name),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: const TextStyle(
                                  color: titleColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.email,
                                style: const TextStyle(
                                  color: subtitleColor,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Tənzimləmələr',
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),

                  BlocBuilder<ThemeCubit, ThemeState>(
                    builder: (context, themeState) {
                      return _ThemeTile(
                        isDarkMode: themeState.isDark,
                        onChanged: (value) {
                          context.read<ThemeCubit>().toggleTheme();
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 6),
                  _ProfileTile(
                    icon: Icons.lock_outline,
                    title: 'Şifrəni dəyiş (coming soon)',
                    subtitle: 'Tezliklə bu hissəni də aktiv edərik.',
                    onTap: () {},
                  ),
                  const SizedBox(height: 18),

                  const Text(
                    'Hesab',
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),

                  _ProfileTile(
                    icon: Icons.logout,
                    title: 'Çıxış et',
                    subtitle: 'Hesabdan çıx və yenidən daxil ol.',
                    isDestructive: true,
                    onTap: () async {
                      await context.read<AuthCubit>().logout();
                      // AuthCubit logout → AuthListener səni artıq / routuna qaytaracaq
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts.first.isNotEmpty ? parts.first[0].toUpperCase() : '?';
    }
    final first = parts[0].isNotEmpty ? parts[0][0] : '';
    final last = parts[1].isNotEmpty ? parts[1][0] : '';
    final res = (first + last).toUpperCase();
    return res.isEmpty ? '?' : res;
  }
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({required this.isDarkMode, required this.onChanged});

  final bool isDarkMode;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    final borderColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF111827)
        : const Color(0xFFE5E7EB);
    final titleColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white;
    final subtitleColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF9CA3AF)
        : const Color(0xFF6B7280);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(
            isDarkMode ? Icons.dark_mode : Icons.light_mode,
            color: titleColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isDarkMode ? 'Qaranlıq rejim' : 'İşıqlı rejim',
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isDarkMode ? 'İşıqlı rejimə keç.' : 'Qaranlıq rejimə keç.',
                  style: TextStyle(color: subtitleColor, fontSize: 11),
                ),
              ],
            ),
          ),
          Switch(
            value: isDarkMode,
            onChanged: onChanged,
            activeTrackColor: const Color(0xFF22C55E),
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    final borderColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF111827)
        : const Color(0xFFE5E7EB);
    final titleColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white;
    final subtitleColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF9CA3AF)
        : const Color(0xFF6B7280);

    final color = isDestructive ? const Color(0xFFF97373) : titleColor;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: subtitleColor, fontSize: 11),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: subtitleColor, size: 18),
          ],
        ),
      ),
    );
  }
}
