import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/code_generator.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';

class CreateMonevScreen extends StatefulWidget {
  const CreateMonevScreen({super.key});

  @override
  State<CreateMonevScreen> createState() => _CreateMonevScreenState();
}

class _CreateMonevScreenState extends State<CreateMonevScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _unitKerjaController = TextEditingController();
  
  String? selectedAuditorId;
  String? selectedAuditeeId;
  DateTime selectedDate = DateTime.now();
  bool _isLoading = false;
  bool _isLoadingUsers = true;

  List<UserModel> auditors = [];
  List<UserModel> auditees = [];
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('is_active', isEqualTo: true)
          .get();

      final users = usersSnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data(), doc.id))
          .toList();

      if (mounted) {
        setState(() {
          // Auditors: Users with Auditor role or dual roles
          auditors = users.where((user) {
            return user.role == UserRole.auditor ||
                UserRole.getDualRoles().contains(user.role);
          }).toList();

          // Auditees: Users with Auditee role or dual roles
          auditees = users.where((user) {
            return user.role == UserRole.auditee ||
                UserRole.getDualRoles().contains(user.role);
          }).toList();

          _isLoadingUsers = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading users: $e');
      if (mounted) {
        setState(() => _isLoadingUsers = false);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _unitKerjaController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _createMonev() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Generate session code
      final sessionCode = CodeGenerator.generateSessionCode();
      final currentUser = _authService.currentUser;

      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      // Create Monev session in Firestore
      final docRef = await FirebaseFirestore.instance.collection('monev_sessions').add({
        'session_code': sessionCode,
        'title': _titleController.text,
        'unit_kerja': _unitKerjaController.text,
        'auditor_id': selectedAuditorId,
        'auditee_id': selectedAuditeeId,
        'scheduled_date': selectedDate.toIso8601String(),
        'status': 'draft',
        'created_by': currentUser.uid,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });

      setState(() => _isLoading = false);

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Sesi Monev Berhasil Dibuat'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Kode sesi Monev Anda:'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        sessionCode,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        // Copy to clipboard
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Kode berhasil disalin'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Simpan kode ini untuk melanjutkan sesi Monev di kemudian hari.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Tutup'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to Monev form
                _startMonev(sessionCode, docRef.id);
              },
              child: const Text('Mulai Monev'),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuat sesi Monev: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _startMonev(String sessionCode, String sessionId) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sesi Monev berhasil dibuat: $sessionCode'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Sesi Monev Baru'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Judul Monev',
                    hintText: 'Contoh: Monev Semester Gasal 2024',
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Judul tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _unitKerjaController,
                  decoration: const InputDecoration(
                    labelText: 'Unit Kerja',
                    hintText: 'Contoh: Fakultas Teknik',
                    prefixIcon: Icon(Icons.business),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Unit kerja tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _selectDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Jadwal',
                      prefixIcon: Icon(Icons.calendar_today),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    child: Text(
                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedAuditorId,
                  decoration: const InputDecoration(
                    labelText: 'Auditor',
                    prefixIcon: Icon(Icons.person_search),
                  ),
                  hint: _isLoadingUsers
                      ? const Text('Memuat...')
                      : const Text('Pilih Auditor'),
                  items: auditors.map((auditor) {
                    return DropdownMenuItem(
                      value: auditor.id,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(auditor.name),
                          Text(
                            auditor.role,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: _isLoadingUsers
                      ? null
                      : (value) {
                          setState(() => selectedAuditorId = value);
                        },
                  validator: (value) {
                    if (value == null) {
                      return 'Auditor harus dipilih';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedAuditeeId,
                  decoration: const InputDecoration(
                    labelText: 'Auditee',
                    prefixIcon: Icon(Icons.person),
                  ),
                  hint: _isLoadingUsers
                      ? const Text('Memuat...')
                      : const Text('Pilih Auditee'),
                  items: auditees.map((auditee) {
                    return DropdownMenuItem(
                      value: auditee.id,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(auditee.name),
                          Text(
                            auditee.role,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: _isLoadingUsers
                      ? null
                      : (value) {
                          setState(() => selectedAuditeeId = value);
                        },
                  validator: (value) {
                    if (value == null) {
                      return 'Auditee harus dipilih';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isLoading || _isLoadingUsers ? null : _createMonev,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Buat Sesi Monev'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
