import 'package:flutter/material.dart';
import '../../models/monev_model.dart';
import '../reports/monev_report_screen.dart';

class MonevDetailScreen extends StatefulWidget {
  final String sessionId;
  final String sessionTitle;

  const MonevDetailScreen({
    super.key,
    required this.sessionId,
    required this.sessionTitle,
  });

  @override
  State<MonevDetailScreen> createState() => _MonevDetailScreenState();
}

class _MonevDetailScreenState extends State<MonevDetailScreen> {
  final List<Map<String, dynamic>> indicators = [
    {
      'id': '1',
      'name': 'Kualitas Pembelajaran',
      'type': 'IKU',
      'category': 'Akademik',
      'achievement': null,
      'evidence': '',
    },
    {
      'id': '2',
      'name': 'Kepuasan Mahasiswa',
      'type': 'IKU',
      'category': 'Akademik',
      'achievement': null,
      'evidence': '',
    },
    {
      'id': '3',
      'name': 'Penelitian Dosen',
      'type': 'IKT',
      'category': 'Penelitian',
      'achievement': null,
      'evidence': '',
    },
  ];

  int getTotalScore() {
    int total = 0;
    for (var indicator in indicators) {
      if (indicator['achievement'] != null) {
        total += AchievementLevel.getScore(indicator['achievement']);
      }
    }
    return total;
  }

  double getAverageScore() {
    final total = getTotalScore();
    final count = indicators.where((i) => i['achievement'] != null).length;
    if (count == 0) return 0;
    return total / count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sessionTitle),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveDraft(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Score Summary Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Total Skor',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        getTotalScore().toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white30,
                  ),
                  Column(
                    children: [
                      const Text(
                        'Rata-rata',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        getAverageScore().toStringAsFixed(2),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Indicators List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: indicators.length,
                itemBuilder: (context, index) {
                  final indicator = indicators[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ExpansionTile(
                      title: Text(indicator['name']),
                      subtitle: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: indicator['type'] == 'IKU'
                                  ? Colors.blue.withValues(alpha: 0.1)
                                  : Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              indicator['type'],
                              style: TextStyle(
                                fontSize: 10,
                                color: indicator['type'] == 'IKU'
                                    ? Colors.blue[700]
                                    : Colors.green[700],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            indicator['category'],
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Tingkat Pencapaian',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              ...AchievementLevel.getAll().map((achievement) {
                                final score =
                                    AchievementLevel.getScore(achievement);
                                return RadioListTile<String>(
                                  title: Text(
                                      '${AchievementLevel.getLabel(achievement)} ($score)'),
                                  value: achievement,
                                  groupValue: indicator['achievement'],
                                  onChanged: (value) {
                                    setState(() {
                                      indicator['achievement'] = value;
                                    });
                                  },
                                );
                              }),
                              const SizedBox(height: 16),
                              TextField(
                                decoration: const InputDecoration(
                                  labelText: 'Link Bukti (Google Drive)',
                                  hintText:
                                      'https://drive.google.com/...',
                                  prefixIcon: Icon(Icons.link),
                                ),
                                onChanged: (value) {
                                  indicator['evidence'] = value;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _saveDraft(),
                child: const Text('Simpan Sementara'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _savePermanen(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Simpan Permanen'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Draft berhasil disimpan'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _savePermanen() {
    // Check if all indicators are evaluated
    final unevaluated =
        indicators.where((i) => i['achievement'] == null).length;

    if (unevaluated > 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Perhatian'),
          content: Text(
              'Masih ada $unevaluated indikator yang belum dinilai. Lanjutkan?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _confirmSave();
              },
              child: const Text('Lanjutkan'),
            ),
          ],
        ),
      );
    } else {
      _confirmSave();
    }
  }

  void _confirmSave() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MonevReportScreen(
          sessionId: widget.sessionId,
          sessionTitle: widget.sessionTitle,
          indicators: indicators,
        ),
      ),
    );
  }
}
