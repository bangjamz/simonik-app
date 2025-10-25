import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedFont = 'Roboto';
  double fontSize = 14.0;
  String logoPath = 'Belum ada logo';
  String kopPath = 'Belum ada kop';
  String? logoUrl;
  String? kopUrl;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('settings')
          .doc('app_config')
          .get();
      
      if (doc.exists) {
        final data = doc.data();
        if (mounted) {
          setState(() {
            logoUrl = data?['logo_url'];
            kopUrl = data?['kop_url'];
            logoPath = logoUrl != null ? 'Logo tersimpan' : 'Belum ada logo';
            kopPath = kopUrl != null ? 'Kop tersimpan' : 'Belum ada kop';
            selectedFont = data?['font_family'] ?? 'Roboto';
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionHeader('Informasi Institusi'),
            _buildSettingTile(
              icon: Icons.business,
              title: 'Nama Institusi',
              subtitle: 'Institut Teknologi dan Kesehatan Mahardika',
              onTap: () => _editInstitutionName(),
            ),
            _buildSettingTile(
              icon: Icons.location_on,
              title: 'Alamat',
              subtitle: 'Cirebon, Jawa Barat',
              onTap: () => _editAddress(),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('Media'),
            _buildSettingTile(
              icon: Icons.image,
              title: 'Logo Institusi',
              subtitle: logoPath,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (logoUrl != null)
                    IconButton(
                      icon: const Icon(Icons.preview),
                      onPressed: () => _showImagePreview(logoUrl!, 'Logo'),
                    ),
                  const Icon(Icons.upload_file),
                ],
              ),
              onTap: _isLoading ? null : () => _uploadLogo(),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Format: PNG/JPG, Ukuran maksimal: 2MB, Rekomendasi: 512x512px',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildSettingTile(
              icon: Icons.document_scanner,
              title: 'Kop Surat',
              subtitle: kopPath,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (kopUrl != null)
                    IconButton(
                      icon: const Icon(Icons.preview),
                      onPressed: () => _showImagePreview(kopUrl!, 'Kop Surat'),
                    ),
                  const Icon(Icons.upload_file),
                ],
              ),
              onTap: _isLoading ? null : () => _uploadKop(),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Format: PNG/JPG, Ukuran maksimal: 2MB, Rekomendasi: 2480x3508px (A4)',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('Tampilan'),
            _buildSettingTile(
              icon: Icons.font_download,
              title: 'Font',
              subtitle: selectedFont,
              trailing: DropdownButton<String>(
                value: selectedFont,
                underline: const SizedBox(),
                items: ['Roboto', 'Arial', 'Times New Roman'].map((font) {
                  return DropdownMenuItem(value: font, child: Text(font));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedFont = value);
                  }
                },
              ),
              onTap: null,
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.format_size),
                title: const Text('Ukuran Font'),
                subtitle: Text('${fontSize.toInt()} pt'),
                trailing: SizedBox(
                  width: 150,
                  child: Slider(
                    value: fontSize,
                    min: 10,
                    max: 20,
                    divisions: 10,
                    label: fontSize.toInt().toString(),
                    onChanged: (value) {
                      setState(() => fontSize = value);
                    },
                  ),
                ),
              ),
            ),
            _buildSettingTile(
              icon: Icons.color_lens,
              title: 'Tema Warna',
              subtitle: 'Biru & Oranye',
              onTap: () => _changeTheme(),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('Sistem'),
            _buildSettingTile(
              icon: Icons.backup,
              title: 'Backup Data',
              subtitle: 'Cadangkan data sistem',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur Backup Data')),
                );
              },
            ),
            _buildSettingTile(
              icon: Icons.info,
              title: 'Tentang Aplikasi',
              subtitle: 'SIMONIK v1.0.0',
              onTap: () => _showAboutDialog(),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pengaturan berhasil disimpan'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              icon: const Icon(Icons.save),
              label: const Text('Simpan Pengaturan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
        onTap: onTap,
      ),
    );
  }

  void _editInstitutionName() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Nama Institusi'),
        content: const TextField(
          decoration: InputDecoration(
            labelText: 'Nama Institusi',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nama institusi berhasil diubah')),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _editAddress() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Alamat'),
        content: const TextField(
          decoration: InputDecoration(
            labelText: 'Alamat',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Alamat berhasil diubah')),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadLogo() async {
    try {
      setState(() => _isLoading = true);
      
      // Pick image
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) {
        setState(() => _isLoading = false);
        return;
      }

      // Check file size (max 2MB)
      final fileSize = await image.length();
      if (fileSize > 2 * 1024 * 1024) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ukuran file maksimal 2MB!'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Upload to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('settings/logo_${DateTime.now().millisecondsSinceEpoch}.png');
      
      UploadTask uploadTask;
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        uploadTask = storageRef.putData(
          bytes,
          SettableMetadata(contentType: 'image/png'),
        );
      } else {
        uploadTask = storageRef.putFile(File(image.path));
      }

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Save URL to Firestore
      await FirebaseFirestore.instance
          .collection('settings')
          .doc('app_config')
          .set({
            'logo_url': downloadUrl,
            'updated_at': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      if (mounted) {
        setState(() {
          logoUrl = downloadUrl;
          logoPath = 'Logo tersimpan';
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logo berhasil diupload!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal upload logo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _uploadKop() async {
    try {
      setState(() => _isLoading = true);
      
      // Pick image
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 90,
      );

      if (image == null) {
        setState(() => _isLoading = false);
        return;
      }

      // Check file size (max 2MB)
      final fileSize = await image.length();
      if (fileSize > 2 * 1024 * 1024) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ukuran file maksimal 2MB!'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Upload to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('settings/kop_${DateTime.now().millisecondsSinceEpoch}.png');
      
      UploadTask uploadTask;
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        uploadTask = storageRef.putData(
          bytes,
          SettableMetadata(contentType: 'image/png'),
        );
      } else {
        uploadTask = storageRef.putFile(File(image.path));
      }

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Save URL to Firestore
      await FirebaseFirestore.instance
          .collection('settings')
          .doc('app_config')
          .set({
            'kop_url': downloadUrl,
            'updated_at': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      if (mounted) {
        setState(() {
          kopUrl = downloadUrl;
          kopPath = 'Kop tersimpan';
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kop surat berhasil diupload!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal upload kop: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _changeTheme() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Tema Warna'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              title: const Text('Biru & Oranye'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tema berhasil diubah')),
                );
              },
            ),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              title: const Text('Hijau & Kuning'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tema berhasil diubah')),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showImagePreview(String imageUrl, String title) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: Text(title),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Column(
                    children: [
                      Icon(Icons.error, size: 48, color: Colors.red),
                      SizedBox(height: 8),
                      Text('Gagal memuat gambar'),
                    ],
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'SIMONIK',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.school,
        size: 48,
        color: Theme.of(context).colorScheme.primary,
      ),
      children: [
        const Text(
          'Sistem Informasi Monitoring dan Evaluasi Indikator Kinerja',
        ),
        const SizedBox(height: 8),
        const Text(
          'Institut Teknologi dan Kesehatan Mahardika',
        ),
      ],
    );
  }
}
