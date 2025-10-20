import 'package:hive/hive.dart';

part 'debt_category.g.dart';

@HiveType(typeId: 7)
class DebtCategory {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final int color;

  @HiveField(4)
  final String icon;

  @HiveField(5)
  final String? description;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime updatedAt;

  const DebtCategory({
    required this.id,
    required this.userId,
    required this.name,
    required this.color,
    required this.icon,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  DebtCategory copyWith({
    String? id,
    String? userId,
    String? name,
    int? color,
    String? icon,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DebtCategory(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class DebtCategoryDefaults {
  static const String uncategorizedId = 'uncategorized';
  static const String uncategorizedName = 'Uncategorized';
  static const int uncategorizedColor = 0xFF9CA3AF;
  static const String uncategorizedIcon = 'folder_open';
}
