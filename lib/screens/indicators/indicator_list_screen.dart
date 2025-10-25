import 'package:flutter/material.dart';

class IndicatorListScreen extends StatefulWidget {
  const IndicatorListScreen({super.key});

  @override
  State<IndicatorListScreen> createState() => _IndicatorListScreenState();
}

class _IndicatorListScreenState extends State<IndicatorListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> ikuList = [
    {
      'name': 'Kualitas Pembelajaran',
      'description': 'Penilaian kualitas proses pembelajaran',
      'category': 'Akademik',
    },
    {
      'name': 'Kepuasan Mahasiswa',
      'description': 'Survei kepuasan mahasiswa terhadap layanan',
      'category': 'Akademik',
    },
  ];

  final List<Map<String, dynamic>> iktList = [
    {
      'name': 'Penelitian Dosen',
      'description': 'Jumlah dan kualitas penelitian dosen',
      'category': 'Penelitian',
    },
    {
      'name': 'Pengabdian Masyarakat',
      'description': 'Kegiatan pengabdian kepada masyarakat',
      'category': 'Pengabdian',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Indikator Kinerja'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'IKU'),
            Tab(text: 'IKT'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddIndicatorDialog(),
          ),
        ],
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildIndicatorList(ikuList, 'IKU'),
            _buildIndicatorList(iktList, 'IKT'),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicatorList(List<Map<String, dynamic>> indicators, String type) {
    if (indicators.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada indikator $type',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => _showAddIndicatorDialog(type: type),
              icon: const Icon(Icons.add),
              label: const Text('Tambah Indikator'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: indicators.length,
      itemBuilder: (context, index) {
        final indicator = indicators[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: type == 'IKU'
                    ? Colors.blue.withValues(alpha: 0.1)
                    : Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.analytics,
                color: type == 'IKU' ? Colors.blue : Colors.green,
              ),
            ),
            title: Text(
              indicator['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              indicator['category'],
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 18),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Hapus', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  _showEditIndicatorDialog(indicator);
                } else if (value == 'delete') {
                  _confirmDelete(indicator);
                }
              },
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Deskripsi:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(indicator['description']),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddIndicatorDialog({String? type}) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final categoryController = TextEditingController();
    String selectedType = type ?? 'IKU';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Indikator'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(
                  labelText: 'Tipe',
                  border: OutlineInputBorder(),
                ),
                items: ['IKU', 'IKT'].map((t) {
                  return DropdownMenuItem(value: t, child: Text(t));
                }).toList(),
                onChanged: (value) {
                  if (value != null) selectedType = value;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Indikator',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  final list = selectedType == 'IKU' ? ikuList : iktList;
                  list.add({
                    'name': nameController.text,
                    'description': descController.text,
                    'category': categoryController.text,
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Indikator berhasil ditambahkan'),
                  ),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showEditIndicatorDialog(Map<String, dynamic> indicator) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit indikator: ${indicator['name']}')),
    );
  }

  void _confirmDelete(Map<String, dynamic> indicator) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Hapus indikator ${indicator['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                ikuList.remove(indicator);
                iktList.remove(indicator);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Indikator berhasil dihapus')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
