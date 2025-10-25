import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/indicator_model.dart';

class IndicatorListScreen extends StatefulWidget {
  const IndicatorListScreen({super.key});

  @override
  State<IndicatorListScreen> createState() => _IndicatorListScreenState();
}

class _IndicatorListScreenState extends State<IndicatorListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Indicator> ikuList = [];
  List<Indicator> iktList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadIndicators();
  }

  Future<void> _loadIndicators() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('indicators')
          .where('is_active', isEqualTo: true)
          .get();

      final indicators = snapshot.docs
          .map((doc) => Indicator.fromMap(doc.data(), doc.id))
          .toList();

      if (mounted) {
        setState(() {
          ikuList = indicators.where((i) => i.type == IndicatorType.iku).toList();
          iktList = indicators.where((i) => i.type == IndicatorType.ikt).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading indicators: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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

  Widget _buildIndicatorList(List<Indicator> indicators, String type) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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
              indicator.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  MeasurementType.getLabel(indicator.measurementType),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                if (indicator.unit != null)
                  Text(
                    'Unit: ${indicator.unit}',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 11,
                    ),
                  ),
              ],
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
                    Text(indicator.description),
                    const SizedBox(height: 12),
                    const Text(
                      'Jenis Penilaian:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(MeasurementType.getLabel(indicator.measurementType)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddIndicatorDialog({String? type}) async {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final unitController = TextEditingController();
    String selectedType = type ?? 'IKU';
    String selectedMeasurementType = MeasurementType.deskripsi;
    String? selectedCategoryId;

    // Load categories
    final categoriesSnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .orderBy('order')
        .get();
    
    final categories = categoriesSnapshot.docs;

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Tambah Indikator'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Tipe Indikator',
                    border: OutlineInputBorder(),
                  ),
                  items: ['IKU', 'IKT'].map((t) {
                    return DropdownMenuItem(value: t, child: Text(t));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => selectedType = value);
                    }
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
                DropdownButtonFormField<String>(
                  value: selectedMeasurementType,
                  decoration: const InputDecoration(
                    labelText: 'Jenis Penilaian',
                    border: OutlineInputBorder(),
                  ),
                  items: MeasurementType.getTypes().map((t) {
                    return DropdownMenuItem(
                      value: t,
                      child: Text(MeasurementType.getLabel(t)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() {
                        selectedMeasurementType = value;
                        // Auto-fill unit based on measurement type
                        final defaultUnit = MeasurementType.getDefaultUnit(value);
                        if (defaultUnit != null) {
                          unitController.text = defaultUnit;
                        }
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: unitController,
                  decoration: const InputDecoration(
                    labelText: 'Satuan (opsional)',
                    hintText: 'Contoh: %, orang, buah',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategoryId,
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    border: OutlineInputBorder(),
                  ),
                  hint: const Text('Pilih Kategori'),
                  items: categories.map((doc) {
                    return DropdownMenuItem(
                      value: doc.id,
                      child: Text(doc.data()['name'] ?? ''),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() => selectedCategoryId = value);
                  },
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
              onPressed: () async {
                if (nameController.text.isNotEmpty && selectedCategoryId != null) {
                  try {
                    // Get max order for new indicator
                    final existingSnapshot = await FirebaseFirestore.instance
                        .collection('indicators')
                        .where('type', isEqualTo: selectedType)
                        .get();
                    
                    final maxOrder = existingSnapshot.docs.isEmpty
                        ? 0
                        : existingSnapshot.docs
                            .map((doc) => doc.data()['order'] as int? ?? 0)
                            .reduce((a, b) => a > b ? a : b);

                    // Save to Firestore
                    await FirebaseFirestore.instance.collection('indicators').add({
                      'name': nameController.text,
                      'description': descController.text,
                      'type': selectedType,
                      'measurement_type': selectedMeasurementType,
                      'unit': unitController.text.isEmpty ? null : unitController.text,
                      'category_id': selectedCategoryId,
                      'order': maxOrder + 1,
                      'is_active': true,
                      'created_at': DateTime.now().toIso8601String(),
                    });

                    // Reload indicators
                    await _loadIndicators();

                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Indikator berhasil ditambahkan'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Gagal menambahkan indikator: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nama indikator dan kategori harus diisi'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditIndicatorDialog(Indicator indicator) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit indikator: ${indicator.name}')),
    );
  }

  void _confirmDelete(Indicator indicator) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Hapus indikator ${indicator.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                // Soft delete - just set is_active to false
                await FirebaseFirestore.instance
                    .collection('indicators')
                    .doc(indicator.id)
                    .update({'is_active': false});

                // Reload indicators
                await _loadIndicators();

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Indikator berhasil dihapus'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal menghapus indikator: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
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
