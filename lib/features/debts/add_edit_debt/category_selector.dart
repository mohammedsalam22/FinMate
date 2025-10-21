import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketsage/providers/providers.dart';
import 'package:pocketsage/data/models/debt_category.dart';
import 'package:pocketsage/core/theme/theme.dart';
import 'package:pocketsage/features/debts/category_details/quick_add_category_dialog.dart';

class CategorySelector extends ConsumerStatefulWidget {
  final String? selectedCategoryId;
  final ValueChanged<String> onCategorySelected;
  final bool enabled;

  const CategorySelector({
    super.key,
    this.selectedCategoryId,
    required this.onCategorySelected,
    this.enabled = true,
  });

  @override
  ConsumerState<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends ConsumerState<CategorySelector> {
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.selectedCategoryId ?? 'uncategorized';
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(debtCategoriesProvider);
    final categoryRepo = ref.watch(debtCategoryRepositoryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        if (categories.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              border: Border.all(
                color: (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary)
                    .withValues(alpha: 0.2),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.folder_open,
                  color: Color(DebtCategoryDefaults.uncategorizedColor),
                ),
                const SizedBox(width: 12),
                Text('Uncategorized'),
                const Spacer(),
                if (widget.enabled)
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _showQuickAddCategory(context),
                  ),
              ],
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((category) {
              final isSelected = _selectedCategoryId == category.id;
              return InkWell(
                onTap:
                    widget.enabled ? () => _selectCategory(category.id) : null,
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Color(category.color).withValues(alpha: 0.2)
                        : (isDark
                            ? AppColors.darkSurface
                            : AppColors.lightSurface),
                    border: Border.all(
                      color: isSelected
                          ? Color(category.color)
                          : (isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary)
                              .withValues(alpha: 0.2),
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        categoryRepo.getIconData(category.icon),
                        color: Color(category.color),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        category.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList()
              ..addAll([
                if (widget.enabled)
                  InkWell(
                    onTap: () => _showQuickAddCategory(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: (isDark
                            ? AppColors.darkSurface
                            : AppColors.lightSurface),
                        border: Border.all(
                          color: (isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary)
                              .withValues(alpha: 0.3),
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add,
                            size: 18,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Add Category',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ]),
          ),
      ],
    );
  }

  void _selectCategory(String categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
    widget.onCategorySelected(categoryId);
  }

  void _showQuickAddCategory(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => QuickAddCategoryDialog(
        onCategoryCreated: (categoryId) {
          setState(() {
            _selectedCategoryId = categoryId;
          });
          widget.onCategorySelected(categoryId);
        },
      ),
    );
  }
}
