import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketsage/providers/providers.dart';
import 'package:pocketsage/core/theme/theme.dart';
import 'package:pocketsage/l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final currentLocale = ref.watch(localeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Language Section
          Text(
            l10n.language,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.language,
                  title: l10n.english,
                  trailing: Radio<Locale?>(
                    value: const Locale('en'),
                    groupValue: currentLocale,
                    onChanged: (locale) {
                      if (locale != null) {
                        ref.read(localeProvider.notifier).setLocale(locale);
                      }
                    },
                  ),
                  onTap: () => ref
                      .read(localeProvider.notifier)
                      .setLocale(const Locale('en')),
                ),
                Divider(
                  height: 1,
                  indent: 64,
                  color: (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary)
                      .withValues(alpha: 0.2),
                ),
                _SettingsTile(
                  icon: Icons.language,
                  title: l10n.arabic,
                  trailing: Radio<Locale?>(
                    value: const Locale('ar'),
                    groupValue: currentLocale,
                    onChanged: (locale) {
                      if (locale != null) {
                        ref.read(localeProvider.notifier).setLocale(locale);
                      }
                    },
                  ),
                  onTap: () => ref
                      .read(localeProvider.notifier)
                      .setLocale(const Locale('ar')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Appearance Section
          Text(
            l10n.appearance,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.light_mode,
                  title: l10n.lightMode,
                  trailing: Radio<ThemeMode>(
                    value: ThemeMode.light,
                    groupValue: themeMode,
                    onChanged: (mode) {
                      if (mode != null) {
                        ref.read(themeModeProvider.notifier).setThemeMode(mode);
                      }
                    },
                  ),
                  onTap: () => ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(ThemeMode.light),
                ),
                Divider(
                  height: 1,
                  indent: 64,
                  color: (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary)
                      .withValues(alpha: 0.2),
                ),
                _SettingsTile(
                  icon: Icons.dark_mode,
                  title: l10n.darkMode,
                  trailing: Radio<ThemeMode>(
                    value: ThemeMode.dark,
                    groupValue: themeMode,
                    onChanged: (mode) {
                      if (mode != null) {
                        ref.read(themeModeProvider.notifier).setThemeMode(mode);
                      }
                    },
                  ),
                  onTap: () => ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(ThemeMode.dark),
                ),
                Divider(
                  height: 1,
                  indent: 64,
                  color: (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary)
                      .withValues(alpha: 0.2),
                ),
                _SettingsTile(
                  icon: Icons.brightness_auto,
                  title: l10n.systemDefault,
                  trailing: Radio<ThemeMode>(
                    value: ThemeMode.system,
                    groupValue: themeMode,
                    onChanged: (mode) {
                      if (mode != null) {
                        ref.read(themeModeProvider.notifier).setThemeMode(mode);
                      }
                    },
                  ),
                  onTap: () => ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(ThemeMode.system),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // About Section
          Text(
            l10n.about,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.info_outline,
                  title: l10n.version,
                  subtitle: '1.0.0',
                  onTap: () {},
                ),
                Divider(
                  height: 1,
                  indent: 64,
                  color: (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary)
                      .withValues(alpha: 0.2),
                ),
                _SettingsTile(
                  icon: Icons.description_outlined,
                  title: l10n.termsAndPrivacy,
                  trailing: Icon(
                    Icons.chevron_right,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color:
                    (isDark ? AppColors.primaryLight : AppColors.primaryIndigo)
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color:
                    isDark ? AppColors.primaryLight : AppColors.primaryIndigo,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
