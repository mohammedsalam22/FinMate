import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketsage/providers/providers.dart';
import 'package:pocketsage/core/theme/theme.dart';

class QuickAddCategoryDialog extends ConsumerStatefulWidget {
  final Function(String categoryId) onCategoryCreated;

  const QuickAddCategoryDialog({
    super.key,
    required this.onCategoryCreated,
  });

  @override
  ConsumerState<QuickAddCategoryDialog> createState() =>
      _QuickAddCategoryDialogState();
}

class _QuickAddCategoryDialogState
    extends ConsumerState<QuickAddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  int _selectedColor = 0xFF2196F3; // Default blue color
  String _selectedIcon = 'folder_open';

  final List<int> _colorOptions = [
    0xFF2196F3, // Blue
    0xFF4CAF50, // Green
    0xFFFF9800, // Orange
    0xFFE91E63, // Pink
    0xFF9C27B0, // Purple
    0xFF00BCD4, // Cyan
    0xFFFF5722, // Deep Orange
    0xFF795548, // Brown
    0xFF607D8B, // Blue Grey
    0xFF3F51B5, // Indigo
  ];

  final List<Map<String, String>> _iconOptions = [
    {'icon': 'folder_open', 'name': 'Folder'},
    {'icon': 'business', 'name': 'Business'},
    {'icon': 'home', 'name': 'Home'},
    {'icon': 'work', 'name': 'Work'},
    {'icon': 'school', 'name': 'School'},
    {'icon': 'restaurant', 'name': 'Restaurant'},
    {'icon': 'local_hospital', 'name': 'Health'},
    {'icon': 'directions_car', 'name': 'Car'},
    {'icon': 'shopping_cart', 'name': 'Shopping'},
    {'icon': 'sports_esports', 'name': 'Games'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categoryRepo = ref.watch(debtCategoryRepositoryProvider);

    return AlertDialog(
      title: const Text('Create New Category'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Name
              Text(
                'Category Name',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'e.g., Cafeteria, Work, Personal',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a category name';
                  }
                  if (value.trim().length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
                autofocus: true,
              ),
              const SizedBox(height: 24),

              // Color Selection
              Text(
                'Color',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _colorOptions.map((color) {
                  final isSelected = _selectedColor == color;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(color),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Color(color).withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Icon Selection
              Text(
                'Icon',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _iconOptions.map((iconInfo) {
                  final isSelected = _selectedIcon == iconInfo['icon'];
                  final iconData = categoryRepo.getIconData(iconInfo['icon']!);
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedIcon = iconInfo['icon']!),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Color(_selectedColor).withValues(alpha: 0.1)
                            : (isDark
                                ? AppColors.darkSurface
                                : AppColors.lightSurface),
                        border: Border.all(
                          color: isSelected
                              ? Color(_selectedColor)
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
                            color: isSelected ? Color(_selectedColor) : null,
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            iconInfo['name']!,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color:
                                      isSelected ? Color(_selectedColor) : null,
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
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              try {
                final category = await categoryRepo.createCategory(
                  name: _nameController.text.trim(),
                  color: _selectedColor,
                  icon: _selectedIcon,
                );

                // Invalidate providers to trigger UI update
                ref.invalidate(debtCategoriesProvider);
                ref.invalidate(debtsGroupedByCategoryProvider);

                widget.onCategoryCreated(category.id);
                if (mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Category "${category.name}" created successfully!'),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error creating category: ${e.toString()}'),
                    ),
                  );
                }
              }
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
