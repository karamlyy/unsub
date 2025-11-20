import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unsub/features/ai/data/repositories/ai_repository.dart';
import 'package:unsub/features/profile/data/repositories/profile_repository.dart';
import 'app.dart';
import 'core/network/api_client.dart';
import 'core/storage/secure_storage.dart';
import 'core/theme/theme_cubit.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/subscriptions/data/repositories/subscriptions_repository.dart';
import 'features/subscriptions/presentation/cubit/subscriptions_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load initial theme from storage before app starts
  final initialTheme = await ThemeCubit.loadInitialTheme();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ApiClient>(
          create: (_) => ApiClient(secureStorage: SecureStorage()),
        ),
        RepositoryProvider<SecureStorage>(create: (_) => SecureStorage()),
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(
            apiClient: context.read<ApiClient>(),
            secureStorage: context.read<SecureStorage>(),
          ),
        ),
        RepositoryProvider<SubscriptionsRepository>(
          create: (context) =>
              SubscriptionsRepository(apiClient: context.read<ApiClient>()),
        ),
        RepositoryProvider<ProfileRepository>(
          create: (context) =>
              ProfileRepository(apiClient: context.read<ApiClient>()),
        ),
        RepositoryProvider<AiRepository>(
          create: (context) => AiRepository(
            apiClient: context.read<ApiClient>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(
            create: (context) => ThemeCubit(initialTheme),
          ),
          BlocProvider<AuthCubit>(
            create: (context) =>
                AuthCubit(authRepository: context.read<AuthRepository>())
                  ..checkAuthStatus(),
          ),
          BlocProvider<SubscriptionsCubit>(
            create: (context) => SubscriptionsCubit(
              subscriptionsRepository: context.read<SubscriptionsRepository>(),
            ),
          ),
        ],
        child: const UnsubApp(),
      ),
    ),
  );
}
