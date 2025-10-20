import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? email;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final Map<String, dynamic> settings;

  User({
    required this.id,
    this.email,
    required this.createdAt,
    Map<String, dynamic>? settings,
  }) : settings = settings ?? {};

  User copyWith({
    String? id,
    String? email,
    DateTime? createdAt,
    Map<String, dynamic>? settings,
  }) =>
      User(
        id: id ?? this.id,
        email: email ?? this.email,
        createdAt: createdAt ?? this.createdAt,
        settings: settings ?? this.settings,
      );
}
