import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketsage/core/constants/constants.dart';
import 'package:pocketsage/data/models/user.dart';
import 'package:pocketsage/data/repositories/settings_repository.dart';
import 'package:pocketsage/data/memory/in_memory_store.dart';
import 'package:uuid/uuid.dart';

final currentUserProvider = Provider<User>((ref) {
  if (kIsWeb) {
    // Web fallback: use in-memory user
    return InMemoryStore.instance.ensureUser();
  } else {
    final userBox = Hive.box<User>(HiveBoxes.users);
    if (userBox.isEmpty) {
      final user = User(
        id: const Uuid().v4(),
        createdAt: DateTime.now().toUtc(),
      );
      userBox.put(user.id, user);
    }
    return userBox.values.first;
  }
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

final localeProvider =
    NotifierProvider<LocaleNotifier, Locale?>(LocaleNotifier.new);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _loadThemeMode();
    return ThemeMode.system;
  }

  Future<void> _loadThemeMode() async {
    final repository = ref.read(settingsRepositoryProvider);
    state = await repository.getThemeMode();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final repository = ref.read(settingsRepositoryProvider);
    await repository.setThemeMode(mode);
    state = mode;
  }
}

class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() {
    _loadLocale();
    return null;
  }

  Future<void> _loadLocale() async {
    final repository = ref.read(settingsRepositoryProvider);
    state = await repository.getLocale();
  }

  Future<void> setLocale(Locale locale) async {
    final repository = ref.read(settingsRepositoryProvider);
    await repository.setLocale(locale);
    state = locale;
  }
}
