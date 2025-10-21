import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketsage/providers/providers.dart';
import 'package:pocketsage/core/constants/category_constants.dart';
import 'package:pocketsage/features/debts/category_details/widgets/color_picker.dart';
import 'package:pocketsage/features/debts/category_details/widgets/icon_picker.dart';
import 'package:pocketsage/l10n/app_localizations.dart';

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
  int _selectedColor = CategoryConstants.defaultColor;
  String _selectedIcon = CategoryConstants.defaultIcon;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryRepo = ref.watch(debtCategoryRepositoryProvider);
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.createNewCategory),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Name
              Text(
                l10n.categoryName,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: l10n.categoryExample,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.enterCategoryName;
                  }
                  if (value.trim().length < 2) {
                    return l10n.nameMinLength;
                  }
                  return null;
                },
                autofocus: true,
              ),
              const SizedBox(height: 24),
              ColorPicker(
                selectedColor: _selectedColor,
                onColorSelected: (color) => setState(() => _selectedColor = color),
              ),
              const SizedBox(height: 24),
              IconPicker(
                selectedIcon: _selectedIcon,
                selectedColor: _selectedColor,
                onIconSelected: (icon) => setState(() => _selectedIcon = icon),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
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
                if (mounted && context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.categoryCreatedSuccess(category.name)),
                    ),
                  );
                }
              } catch (e) {
                if (mounted && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.errorCreatingCategory(e.toString())),
                    ),
                  );
                }
              }
            }
          },
          child: Text(l10n.create),
        ),
      ],
    );
  }
}
