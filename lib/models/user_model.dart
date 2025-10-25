class UserModel {
  final String id;
  final String email;
  final String name;
  final String role;
  final List<String> permissions;
  final DateTime createdAt;
  final bool isActive;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.permissions,
    required this.createdAt,
    this.isActive = true,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: data['role'] ?? '',
      permissions: List<String>.from(data['permissions'] ?? []),
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'] as String)
          : DateTime.now(),
      isActive: data['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'role': role,
      'permissions': permissions,
      'created_at': createdAt.toIso8601String(),
      'is_active': isActive,
    };
  }
}

// Predefined roles
class UserRole {
  static const String admin = 'Admin';
  static const String ketuaLPM = 'Ketua LPM';
  static const String lpm = 'LPM';
  static const String rektor = 'Rektor';
  static const String rektorat = 'Rektorat';
  static const String dekan = 'Dekan';
  static const String kaprodi = 'Kaprodi';
  static const String biro = 'Biro';
  static const String lppm = 'LPPM';
  static const String auditor = 'Auditor';
  static const String auditee = 'Auditee';

  static List<String> getAllRoles() {
    return [
      admin,
      ketuaLPM,
      lpm,
      rektor,
      rektorat,
      dekan,
      kaprodi,
      biro,
      lppm,
      auditor,
      auditee,
    ];
  }

  static List<String> getDualRoles() {
    // Roles that can be both auditor and auditee
    return [rektor, rektorat, dekan, kaprodi];
  }
}

// Permissions
class Permissions {
  static const String manageUsers = 'manage_users';
  static const String manageIndicators = 'manage_indicators';
  static const String manageMonev = 'manage_monev';
  static const String viewAllReports = 'view_all_reports';
  static const String conductMonev = 'conduct_monev';
  static const String viewOwnReports = 'view_own_reports';
  static const String manageSettings = 'manage_settings';
  static const String exportPDF = 'export_pdf';

  static List<String> getFullPermissions() {
    return [
      manageUsers,
      manageIndicators,
      manageMonev,
      viewAllReports,
      conductMonev,
      viewOwnReports,
      manageSettings,
      exportPDF,
    ];
  }

  static List<String> getPermissionsByRole(String role) {
    switch (role) {
      case UserRole.admin:
      case UserRole.ketuaLPM:
        return getFullPermissions();
      case UserRole.lpm:
        return [
          manageIndicators,
          manageMonev,
          viewAllReports,
          conductMonev,
          exportPDF,
        ];
      case UserRole.auditor:
        return [conductMonev, viewOwnReports, exportPDF];
      case UserRole.auditee:
        return [viewOwnReports];
      default:
        return [conductMonev, viewOwnReports, exportPDF];
    }
  }
}
