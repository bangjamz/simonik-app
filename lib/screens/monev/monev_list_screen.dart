import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'create_monev_screen.dart';
import 'monev_detail_screen.dart';

class MonevListScreen extends StatefulWidget {
  const MonevListScreen({super.key});

  @override
  State<MonevListScreen> createState() => _MonevListScreenState();
}

class _MonevListScreenState extends State<MonevListScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> monevSessions = [];

  @override
  void initState() {
    super.initState();
    _loadMonevSessions();
  }

  Future<void> _loadMonevSessions() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('monev_sessions')
          .orderBy('created_at', descending: true)
          .get();

      // Get user data for auditors and auditees
      final sessions = <Map<String, dynamic>>[];
      for (final doc in snapshot.docs) {
        final data = doc.data();
        
        // Get auditor name
        String auditorName = 'Loading...';
        if (data['auditor_id'] != null) {
          final auditorDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(data['auditor_id'])
              .get();
          if (auditorDoc.exists) {
            auditorName = auditorDoc.data()?['name'] ?? 'Unknown';
          }
        }

        // Format date
        String dateStr = 'N/A';
        if (data['scheduled_date'] != null) {
          try {
            final date = DateTime.parse(data['scheduled_date']);
            dateStr = DateFormat('dd MMM yyyy').format(date);
          } catch (e) {
            debugPrint('Error parsing date: $e');
          }
        }

        sessions.add({
          'id': doc.id,
          'title': data['title'] ?? 'Untitled',
          'unit_kerja': data['unit_kerja'] ?? 'N/A',
          'status': data['status'] ?? 'draft',
          'date': dateStr,
          'auditor': auditorName,
          'session_code': data['session_code'] ?? '',
        });
      }

      if (mounted) {
        setState(() {
          monevSessions = sessions;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading monev sessions: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoring & Evaluasi'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur pencarian')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : monevSessions.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 80,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada sesi Monev',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreateMonevScreen(),
                          ),
                        );
                        // Reload sessions after creating new one
                        _loadMonevSessions();
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Buat Monev Baru'),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: monevSessions.length,
                itemBuilder: (context, index) {
                  final session = monevSessions[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MonevDetailScreen(
                              sessionId: session['id'],
                              sessionTitle: session['title'],
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    session['title'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                _StatusBadge(status: session['status']),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.business,
                                    size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 8),
                                Text(
                                  session['unit_kerja'],
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 8),
                                Text(
                                  session['date'],
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.person,
                                    size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 8),
                                Text(
                                  'Auditor: ${session['auditor']}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateMonevScreen(),
            ),
          );
          // Reload sessions after creating new one
          _loadMonevSessions();
        },
        icon: const Icon(Icons.add),
        label: const Text('Monev Baru'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case 'completed':
        bgColor = Colors.green.withValues(alpha: 0.1);
        textColor = Colors.green;
        label = 'Selesai';
        break;
      case 'in_progress':
        bgColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange;
        label = 'Berlangsung';
        break;
      default:
        bgColor = Colors.grey.withValues(alpha: 0.1);
        textColor = Colors.grey;
        label = 'Draft';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
