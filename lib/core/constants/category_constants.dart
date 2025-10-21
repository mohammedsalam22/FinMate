/// Category-related constants for the application
class CategoryConstants {
  CategoryConstants._();

  /// Available color options for categories
  static const List<int> colorOptions = [
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

  /// Available icon options for categories
  /// Each map contains 'icon' (the icon name) and 'name' (the translation key)
  static const List<Map<String, String>> iconOptions = [
    {'icon': 'folder_open', 'name': 'iconFolder'},
    {'icon': 'business', 'name': 'iconBusiness'},
    {'icon': 'home', 'name': 'iconHome'},
    {'icon': 'work', 'name': 'iconWork'},
    {'icon': 'school', 'name': 'iconSchool'},
    {'icon': 'restaurant', 'name': 'iconRestaurant'},
    {'icon': 'local_hospital', 'name': 'iconHealth'},
    {'icon': 'directions_car', 'name': 'iconCar'},
    {'icon': 'shopping_cart', 'name': 'iconShopping'},
    {'icon': 'sports_esports', 'name': 'iconGames'},
  ];

  /// Default category color
  static const int defaultColor = 0xFF2196F3;

  /// Default category icon
  static const String defaultIcon = 'folder_open';
}

