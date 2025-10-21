import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketsage/providers/providers.dart';
import 'package:pocketsage/data/models/debt_category.dart';
import 'package:pocketsage/core/theme/theme.dart';

class DebtCategoryCard extends ConsumerStatefulWidget {
  final DebtCategory category;

  const DebtCategoryCard({super.key, required this.category});

  @override
  ConsumerState<DebtCategoryCard> createState() => _DebtCategoryCardState();
}

class _DebtCategoryCardState extends ConsumerState<DebtCategoryCard> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categoryRepo = ref.watch(debtCategoryRepositoryProvider);
    final stats = categoryRepo.getCategoryStats(widget.category.id);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Card(
        child: Column(
          children: [
            // Category Header
            InkWell(
              onTap: () =>
                  context.push('/category-details/${widget.category.id}'),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            Color(widget.category.color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        categoryRepo.getIconData(widget.category.icon),
                        color: Color(widget.category.color),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.category.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${stats['totalDebts']} debt${stats['totalDebts'] == 1 ? '' : 's'} • €${stats['totalRemaining']?.toStringAsFixed(0) ?? '0'} remaining',
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(widget.category.color)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '€${stats['totalOwed']?.toStringAsFixed(0) ?? '0'}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Color(widget.category.color),
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
