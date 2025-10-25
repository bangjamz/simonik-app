class AppSettings {
  final String id;
  final String institutionName;
  final String institutionAddress;
  final String? logoUrl;
  final String? kopUrl;
  final String fontFamily;
  final double fontSize;
  final String primaryColor;
  final String secondaryColor;
  final DateTime updatedAt;

  AppSettings({
    required this.id,
    this.institutionName = 'Institut Teknologi dan Kesehatan Mahardika',
    this.institutionAddress = 'Cirebon',
    this.logoUrl,
    this.kopUrl,
    this.fontFamily = 'Roboto',
    this.fontSize = 14.0,
    this.primaryColor = '#1976D2',
    this.secondaryColor = '#FF9800',
    required this.updatedAt,
  });

  factory AppSettings.fromMap(Map<String, dynamic> data, String id) {
    return AppSettings(
      id: id,
      institutionName: data['institution_name'] ?? 
          'Institut Teknologi dan Kesehatan Mahardika',
      institutionAddress: data['institution_address'] ?? 'Cirebon',
      logoUrl: data['logo_url'],
      kopUrl: data['kop_url'],
      fontFamily: data['font_family'] ?? 'Roboto',
      fontSize: (data['font_size'] ?? 14.0).toDouble(),
      primaryColor: data['primary_color'] ?? '#1976D2',
      secondaryColor: data['secondary_color'] ?? '#FF9800',
      updatedAt: data['updated_at'] != null
          ? DateTime.parse(data['updated_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'institution_name': institutionName,
      'institution_address': institutionAddress,
      'logo_url': logoUrl,
      'kop_url': kopUrl,
      'font_family': fontFamily,
      'font_size': fontSize,
      'primary_color': primaryColor,
      'secondary_color': secondaryColor,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
