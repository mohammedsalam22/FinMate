import 'package:hive/hive.dart';

part 'category.g.dart';

enum CategoryType {
  income,
  expense,
}

@HiveType(typeId: 1)
class Category {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String icon;

  @HiveField(4)
  final int color;

  @HiveField(5)
  final CategoryType type;

  Category({
    required this.id,
    required this.userId,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
  });

  Category copyWith({
    String? id,
    String? userId,
    String? name,
    String? icon,
    int? color,
    CategoryType? type,
  }) =>
      Category(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        icon: icon ?? this.icon,
        color: color ?? this.color,
        type: type ?? this.type,
      );
}
