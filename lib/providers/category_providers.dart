import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketsage/core/constants/constants.dart';
import 'package:pocketsage/data/models/category.dart';
import 'package:pocketsage/data/repositories/category_repository.dart';
import 'package:pocketsage/data/memory/in_memory_store.dart';
import 'package:pocketsage/providers/app_providers.dart';

final categoryBoxEventsProvider = StreamProvider<BoxEvent>((ref) {
  return Hive.box<Category>(HiveBoxes.categories).watch();
});

final categoryRepositoryProvider = Provider<dynamic>((ref) {
  final user = ref.watch(currentUserProvider);
  if (kIsWeb) {
    return CategoryRepositoryMemory(user.id);
  } else {
    final box = Hive.box<Category>(HiveBoxes.categories);
    return CategoryRepository(box, user.id);
  }
});

final categoriesProvider = Provider<List<Category>>((ref) {
  if (kIsWeb) {
    final repository =
        ref.watch(categoryRepositoryProvider) as CategoryRepositoryMemory;
    return repository.getAll();
  } else {
    // Watch Hive box events to refresh on changes
    ref.watch(categoryBoxEventsProvider);
    final repository =
        ref.watch(categoryRepositoryProvider) as CategoryRepository;
    return repository.getAll();
  }
});
