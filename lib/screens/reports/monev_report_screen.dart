import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/monev_model.dart';

class MonevReportScreen extends StatelessWidget {
  final String sessionId;
  final String sessionTitle;
  final List<Map<String, dynamic>> indicators;

  const MonevReportScreen({
    super.key,
    required this.sessionId,
    required this.sessionTitle,
    required this.indicators,
  });

  Map<String, List<Map<String, dynamic>>> _groupByCategory() {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var indicator in indicators) {
      final category = indicator['category'] ?? 'Lainnya';
      grouped[category] ??= [];
      grouped[category]!.add(indicator);
    }
    return grouped;
  }

  int _getTotalScore() {
    int total = 0;
    for (var indicator in indicators) {
      if (indicator['achievement'] != null) {
        total += AchievementLevel.getScore(indicator['achievement']);
      }
    }
    return total;
  }

  double _getAverageScore() {
    final total = _getTotalScore();
    final count = indicators.where((i) => i['achievement'] != null).length;
    if (count == 0) return 0;
    return total / count;
  }

  Map<String, int> _getAchievementCounts() {
    final Map<String, int> counts = {
      'melampaui': 0,
      'tercapai': 0,
      'belum_tercapai': 0,
      'tidak_dilakukan': 0,
    };

    for (var indicator in indicators) {
      if (indicator['achievement'] != null) {
        counts[indicator['achievement']] = 
            (counts[indicator['achievement']] ?? 0) + 1;
      }
    }

    return counts;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByCategory();
    final achievementCounts = _getAchievementCounts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Monev'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _exportPDF(context),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareReport(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              Card(
                color: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Laporan Monitoring & Evaluasi',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        sessionTitle,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tanggal: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Score Summary
              Row(
                children: [
                  Expanded(
                    child: _ScoreCard(
                      title: 'Total Skor',
                      value: _getTotalScore().toString(),
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ScoreCard(
                      title: 'Rata-rata',
                      value: _getAverageScore().toStringAsFixed(2),
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Achievement Bar Chart
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Grafik Ketercapaian',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 250,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: indicators.length.toDouble(),
                            barGroups: [
                              BarChartGroupData(
                                x: 0,
                                barRods: [
                                  BarChartRodData(
                                    toY: achievementCounts['melampaui']!.toDouble(),
                                    color: Colors.green,
                                    width: 40,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 1,
                                barRods: [
                                  BarChartRodData(
                                    toY: achievementCounts['tercapai']!.toDouble(),
                                    color: Colors.blue,
                                    width: 40,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 2,
                                barRods: [
                                  BarChartRodData(
                                    toY: achievementCounts['belum_tercapai']!.toDouble(),
                                    color: Colors.orange,
                                    width: 40,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 3,
                                barRods: [
                                  BarChartRodData(
                                    toY: achievementCounts['tidak_dilakukan']!.toDouble(),
                                    color: Colors.red,
                                    width: 40,
                                  ),
                                ],
                              ),
                            ],
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    switch (value.toInt()) {
                                      case 0:
                                        return const Text('Melampaui');
                                      case 1:
                                        return const Text('Tercapai');
                                      case 2:
                                        return const Text('Belum');
                                      case 3:
                                        return const Text('Tidak');
                                      default:
                                        return const Text('');
                                    }
                                  },
                                ),
                              ),
                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: true),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            gridData: const FlGridData(show: true),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Radar Chart per Category
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Skor per Kategori',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...grouped.entries.map((entry) {
                        final categoryScore = entry.value
                            .where((i) => i['achievement'] != null)
                            .fold<int>(
                                0,
                                (sum, i) =>
                                    sum +
                                    AchievementLevel.getScore(
                                        i['achievement']));
                        final avgScore = entry.value.isNotEmpty
                            ? categoryScore / entry.value.length
                            : 0;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    entry.key,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${avgScore.toStringAsFixed(2)}/4.0',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: avgScore / 4.0,
                                backgroundColor: Colors.grey[200],
                                color: Theme.of(context).colorScheme.primary,
                                minHeight: 8,
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Detail Table
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Detail Penilaian',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Table(
                        border: TableBorder.all(color: Colors.grey[300]!),
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(1),
                          2: FlexColumnWidth(1),
                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                            ),
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Indikator',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Pencapaian',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Skor',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          ...indicators.map((indicator) {
                            final achievement = indicator['achievement'];
                            final score = achievement != null
                                ? AchievementLevel.getScore(achievement)
                                : 0;

                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(indicator['name']),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    achievement != null
                                        ? AchievementLevel.getLabel(achievement)
                                        : '-',
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(score.toString()),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _exportPDF(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export PDF'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.picture_as_pdf, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text('Laporan akan diekspor ke PDF dengan kop surat.'),
          ],
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
                const SnackBar(
                  content: Text('PDF berhasil diekspor'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _shareReport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fitur share laporan')),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _ScoreCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
