import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketsage/core/constants/category_constants.dart';
import 'package:pocketsage/core/theme/theme.dart';
import 'package:pocketsage/l10n/app_localizations.dart';
import 'package:pocketsage/providers/providers.dart';

class IconPicker extends ConsumerWidget {
  final String selectedIcon;
  final int selectedColor;
  final ValueChanged<String> onIconSelected;

  const IconPicker({
    super.key,
    required this.selectedIcon,
    required this.selectedColor,
    required this.onIconSelected,
  });

  String _getIconName(AppLocalizations l10n, String iconKey) {
    switch (iconKey) {
      case 'iconFolder':
        return l10n.iconFolder;
      case 'iconBusiness':
        return l10n.iconBusiness;
      case 'iconHome':
        return l10n.iconHome;
      case 'iconWork':
        return l10n.iconWork;
      case 'iconSchool':
        return l10n.iconSchool;
      case 'iconRestaurant':
        return l10n.iconRestaurant;
      case 'iconHealth':
        return l10n.iconHealth;
      case 'iconCar':
        return l10n.iconCar;
      case 'iconShopping':
        return l10n.iconShopping;
      case 'iconGames':
        return l10n.iconGames;
      default:
        return iconKey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categoryRepo = ref.watch(debtCategoryRepositoryProvider);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.icon,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: CategoryConstants.iconOptions.map((iconInfo) {
            final isSelected = selectedIcon == iconInfo['icon'];
            final iconData = categoryRepo.getIconData(iconInfo['icon']!);
            return GestureDetector(
              onTap: () => onIconSelected(iconInfo['icon']!),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Color(selectedColor).withValues(alpha: 0.1)
                      : (isDark
                          ? AppColors.darkSurface
                          : AppColors.lightSurface),
                  border: Border.all(
                    color: isSelected
                        ? Color(selectedColor)
                        : (isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary)
                            .withValues(alpha: 0.2),
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      iconData,
                      color: isSelected ? Color(selectedColor) : null,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getIconName(l10n, iconInfo['name']!),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isSelected ? Color(selectedColor) : null,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

