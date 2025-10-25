class IndicatorCategory {
  final String id;
  final String name;
  final String? parentId; // For sub-category
  final int order;
  final DateTime createdAt;

  IndicatorCategory({
    required this.id,
    required this.name,
    this.parentId,
    required this.order,
    required this.createdAt,
  });

  factory IndicatorCategory.fromMap(Map<String, dynamic> data, String id) {
    return IndicatorCategory(
      id: id,
      name: data['name'] ?? '',
      parentId: data['parent_id'],
      order: data['order'] ?? 0,
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'parent_id': parentId,
      'order': order,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class Indicator {
  final String id;
  final String name;
  final String description;
  final String type; // 'IKU' or 'IKT'
  final String categoryId;
  final String? subCategoryId;
  final int order;
  final DateTime createdAt;
  final bool isActive;

  Indicator({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.categoryId,
    this.subCategoryId,
    required this.order,
    required this.createdAt,
    this.isActive = true,
  });

  factory Indicator.fromMap(Map<String, dynamic> data, String id) {
    return Indicator(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      type: data['type'] ?? 'IKU',
      categoryId: data['category_id'] ?? '',
      subCategoryId: data['sub_category_id'],
      order: data['order'] ?? 0,
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'] as String)
          : DateTime.now(),
      isActive: data['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'type': type,
      'category_id': categoryId,
      'sub_category_id': subCategoryId,
      'order': order,
      'created_at': createdAt.toIso8601String(),
      'is_active': isActive,
    };
  }
}

class IndicatorType {
  static const String iku = 'IKU';
  static const String ikt = 'IKT';

  static List<String> getTypes() {
    return [iku, ikt];
  }
}
