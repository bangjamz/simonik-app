class MonevSession {
  final String id;
  final String title;
  final String unitKerja; // Unit kerja yang dimonev
  final String auditorId;
  final String auditorName;
  final String auditeeId;
  final String auditeeName;
  final DateTime scheduledDate;
  final String sessionCode; // Code untuk melanjutkan session
  final String status; // 'draft', 'in_progress', 'completed'
  final DateTime createdAt;
  final DateTime? completedAt;

  MonevSession({
    required this.id,
    required this.title,
    required this.unitKerja,
    required this.auditorId,
    required this.auditorName,
    required this.auditeeId,
    required this.auditeeName,
    required this.scheduledDate,
    required this.sessionCode,
    required this.status,
    required this.createdAt,
    this.completedAt,
  });

  factory MonevSession.fromMap(Map<String, dynamic> data, String id) {
    return MonevSession(
      id: id,
      title: data['title'] ?? '',
      unitKerja: data['unit_kerja'] ?? '',
      auditorId: data['auditor_id'] ?? '',
      auditorName: data['auditor_name'] ?? '',
      auditeeId: data['auditee_id'] ?? '',
      auditeeName: data['auditee_name'] ?? '',
      scheduledDate: data['scheduled_date'] != null
          ? DateTime.parse(data['scheduled_date'] as String)
          : DateTime.now(),
      sessionCode: data['session_code'] ?? '',
      status: data['status'] ?? 'draft',
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'] as String)
          : DateTime.now(),
      completedAt: data['completed_at'] != null
          ? DateTime.parse(data['completed_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'unit_kerja': unitKerja,
      'auditor_id': auditorId,
      'auditor_name': auditorName,
      'auditee_id': auditeeId,
      'auditee_name': auditeeName,
      'scheduled_date': scheduledDate.toIso8601String(),
      'session_code': sessionCode,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}

class MonevEvaluation {
  final String id;
  final String sessionId;
  final String indicatorId;
  final String indicatorName;
  final String indicatorType; // IKU or IKT
  final String categoryId;
  final String categoryName;
  final String achievement; // 'melampaui', 'tercapai', 'belum_tercapai', 'tidak_dilakukan'
  final int score; // 4, 3, 2, 1
  final String? evidenceLink; // Google Drive link
  final String? notes;
  final DateTime evaluatedAt;

  MonevEvaluation({
    required this.id,
    required this.sessionId,
    required this.indicatorId,
    required this.indicatorName,
    required this.indicatorType,
    required this.categoryId,
    required this.categoryName,
    required this.achievement,
    required this.score,
    this.evidenceLink,
    this.notes,
    required this.evaluatedAt,
  });

  factory MonevEvaluation.fromMap(Map<String, dynamic> data, String id) {
    return MonevEvaluation(
      id: id,
      sessionId: data['session_id'] ?? '',
      indicatorId: data['indicator_id'] ?? '',
      indicatorName: data['indicator_name'] ?? '',
      indicatorType: data['indicator_type'] ?? '',
      categoryId: data['category_id'] ?? '',
      categoryName: data['category_name'] ?? '',
      achievement: data['achievement'] ?? '',
      score: data['score'] ?? 0,
      evidenceLink: data['evidence_link'],
      notes: data['notes'],
      evaluatedAt: data['evaluated_at'] != null
          ? DateTime.parse(data['evaluated_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'session_id': sessionId,
      'indicator_id': indicatorId,
      'indicator_name': indicatorName,
      'indicator_type': indicatorType,
      'category_id': categoryId,
      'category_name': categoryName,
      'achievement': achievement,
      'score': score,
      'evidence_link': evidenceLink,
      'notes': notes,
      'evaluated_at': evaluatedAt.toIso8601String(),
    };
  }
}

class AchievementLevel {
  static const String melampaui = 'melampaui';
  static const String tercapai = 'tercapai';
  static const String belumTercapai = 'belum_tercapai';
  static const String tidakDilakukan = 'tidak_dilakukan';

  static int getScore(String achievement) {
    switch (achievement) {
      case melampaui:
        return 4;
      case tercapai:
        return 3;
      case belumTercapai:
        return 2;
      case tidakDilakukan:
        return 1;
      default:
        return 0;
    }
  }

  static String getLabel(String achievement) {
    switch (achievement) {
      case melampaui:
        return 'Melampaui';
      case tercapai:
        return 'Tercapai';
      case belumTercapai:
        return 'Belum Tercapai';
      case tidakDilakukan:
        return 'Tidak Dilakukan';
      default:
        return '';
    }
  }

  static List<String> getAll() {
    return [melampaui, tercapai, belumTercapai, tidakDilakukan];
  }
}

class MonevStatus {
  static const String draft = 'draft';
  static const String inProgress = 'in_progress';
  static const String completed = 'completed';
}
