import 'package:flutter/material.dart';
import 'package:pocketsage/core/theme/theme.dart';

class NeumorphicBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<NeumorphicNavItem> items;

  const NeumorphicBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  State<NeumorphicBottomNavigationBar> createState() =>
      _NeumorphicBottomNavigationBarState();
}

class _NeumorphicBottomNavigationBarState
    extends State<NeumorphicBottomNavigationBar> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        boxShadow: [
          // Outer shadow (darker)
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.3),
            offset: const Offset(8, 8),
            blurRadius: 16,
            spreadRadius: 0,
          ),
          // Inner shadow (lighter)
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.8),
            offset: const Offset(-8, -8),
            blurRadius: 16,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // First two tabs (Transactions, Debts)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(0, widget.items[0], isDark),
                  _buildNavItem(1, widget.items[1], isDark),
                ],
              ),
            ),
            // Center AI tab - Floating design
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: _buildFloatingNavItem(4, widget.items[4], isDark),
            ),
            // Last two tabs (Analytics, Settings)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(2, widget.items[2], isDark),
                  _buildNavItem(3, widget.items[3], isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingNavItem(int index, NeumorphicNavItem item, bool isDark) {
    final isSelected = index == widget.currentIndex;

    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) {
        _animationController.reverse();
        widget.onTap(index);
      },
      onTapCancel: () => _animationController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: isSelected ? 1.0 : _scaleAnimation.value,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: isDark
                    ? AppColors.darkBackground
                    : AppColors.lightBackground,
                boxShadow: [
                  // Stronger outer shadow for floating effect
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.4)
                        : Colors.grey.withValues(alpha: 0.4),
                    offset: const Offset(6, 6),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                  // Stronger inner shadow
                  BoxShadow(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.white.withValues(alpha: 0.9),
                    offset: const Offset(-6, -6),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                  // Additional floating shadow
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.2)
                        : Colors.grey.withValues(alpha: 0.2),
                    offset: const Offset(0, 8),
                    blurRadius: 20,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon directly without inner circle
                  Icon(
                    isSelected ? item.selectedIcon : item.icon,
                    color: isSelected
                        ? AppColors.primaryIndigo
                        : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                    size: 24,
                  ),
                  const SizedBox(height: 2),
                  // Label
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected
                          ? AppColors.primaryIndigo
                          : (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavItem(int index, NeumorphicNavItem item, bool isDark,
      {bool isCenter = false}) {
    final isSelected = index == widget.currentIndex;

    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) {
        _animationController.reverse();
        widget.onTap(index);
      },
      onTapCancel: () => _animationController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: isSelected ? 1.0 : _scaleAnimation.value,
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: isCenter ? 8 : 4,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isSelected
                    ? AppColors.primaryIndigo.withValues(alpha: 0.1)
                    : Colors.transparent,
                boxShadow: isSelected
                    ? [
                        // Selected item shadow
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withValues(alpha: 0.2)
                              : Colors.grey.withValues(alpha: 0.2),
                          offset: const Offset(4, 4),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.03)
                              : Colors.white.withValues(alpha: 0.6),
                          offset: const Offset(-4, -4),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon with neumorphic effect
                  Container(
                    width: isCenter ? 40 : 36,
                    height: isCenter ? 40 : 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(isCenter ? 20 : 18),
                      color: isDark
                          ? AppColors.darkBackground
                          : AppColors.lightBackground,
                      boxShadow: [
                        // Outer shadow
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withValues(alpha: 0.3)
                              : Colors.grey.withValues(alpha: 0.3),
                          offset: const Offset(3, 3),
                          blurRadius: 6,
                          spreadRadius: 0,
                        ),
                        // Inner shadow
                        BoxShadow(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.white.withValues(alpha: 0.8),
                          offset: const Offset(-3, -3),
                          blurRadius: 6,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Icon(
                      isSelected ? item.selectedIcon : item.icon,
                      color: isSelected
                          ? AppColors.primaryIndigo
                          : (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary),
                      size: isCenter ? 20 : 18,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Label
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: isCenter ? 10 : 9,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected
                          ? AppColors.primaryIndigo
                          : (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class NeumorphicNavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const NeumorphicNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}
