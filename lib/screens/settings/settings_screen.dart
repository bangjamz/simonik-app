import 'package:flutter/material.dart';

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
              title: 'Logo',
              subtitle: logoPath,
              trailing: const Icon(Icons.upload_file),
              onTap: () => _uploadLogo(),
            ),
            _buildSettingTile(
              icon: Icons.document_scanner,
              title: 'Kop Surat',
              subtitle: kopPath,
              trailing: const Icon(Icons.upload_file),
              onTap: () => _uploadKop(),
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

  void _uploadLogo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upload Logo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Pilih file logo (PNG, JPG, maksimal 2MB)'),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                setState(() => logoPath = 'logo.png');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logo berhasil diupload')),
                );
              },
              icon: const Icon(Icons.upload_file),
              label: const Text('Pilih File'),
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

  void _uploadKop() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upload Kop Surat'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Pilih file kop (PNG, JPG, maksimal 2MB)'),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                setState(() => kopPath = 'kop.png');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Kop surat berhasil diupload')),
                );
              },
              icon: const Icon(Icons.upload_file),
              label: const Text('Pilih File'),
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
