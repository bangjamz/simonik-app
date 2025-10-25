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
  final String measurementType; // 'Persentase', 'Rasio', 'Deskripsi', 'Angka'
  final String? unit; // Unit measurement (%, orang, buah, etc.)
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
    required this.measurementType,
    this.unit,
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
      measurementType: data['measurement_type'] ?? MeasurementType.deskripsi,
      unit: data['unit'],
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
      'measurement_type': measurementType,
      'unit': unit,
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

class MeasurementType {
  static const String persentase = 'Persentase';
  static const String rasio = 'Rasio';
  static const String deskripsi = 'Deskripsi';
  static const String angka = 'Angka';

  static List<String> getTypes() {
    return [persentase, rasio, deskripsi, angka];
  }

  static String getLabel(String type) {
    switch (type) {
      case persentase:
        return 'Persentase (%)';
      case rasio:
        return 'Rasio (x:y)';
      case deskripsi:
        return 'Deskripsi (Teks)';
      case angka:
        return 'Angka (Numeric)';
      default:
        return type;
    }
  }

  static String? getDefaultUnit(String type) {
    switch (type) {
      case persentase:
        return '%';
      case rasio:
        return 'rasio';
      case angka:
        return 'unit';
      default:
        return null;
    }
  }
}
