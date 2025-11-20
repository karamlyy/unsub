import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const _themeKey = 'theme_mode';

  ThemeCubit(ThemeState initialState) : super(initialState);

  // Static method to load initial theme
  static Future<ThemeState> loadInitialTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeKey) ?? true; // default dark
    print('🎨 Loading initial theme: ${isDark ? "Dark" : "Light"}');
    return isDark ? const ThemeDark() : const ThemeLight();
  }

  Future<void> toggleTheme() async {
    final newState = state.isDark ? const ThemeLight() : const ThemeDark();
    print('🎨 Toggling theme to: ${newState.isDark ? "Dark" : "Light"}');
    emit(newState);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, newState.isDark);
    print('💾 Theme saved to storage: ${newState.isDark ? "Dark" : "Light"}');
  }

  Future<void> setLightTheme() async {
    emit(const ThemeLight());
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, false);
  }

  Future<void> setDarkTheme() async {
    emit(const ThemeDark());
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, true);
  }
}
