import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../providers/mood_provider.dart';
import '../models/mood_entry_model.dart';

class MoodTrackingScreen extends StatefulWidget {
  const MoodTrackingScreen({super.key});

  @override
  State<MoodTrackingScreen> createState() => _MoodTrackingScreenState();
}

class _MoodTrackingScreenState extends State<MoodTrackingScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  MoodType? _selectedMood;
  final List<String> _selectedFactors = [];
  final TextEditingController _notesController = TextEditingController();

  static const List<String> moodFactors = [
    'Work',
    'Family',
    'Relationships',
    'Health',
    'Finances',
    'Social',
    'Sleep',
    'Exercise',
    'Weather',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Load entries when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MoodProvider>(context, listen: false).initialize();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Tracking'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.edit)),
            Tab(icon: Icon(Icons.history)),
            Tab(icon: Icon(Icons.analytics)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMoodTrackingTab(),
          _buildHistoryTab(),
          _buildAnalyticsTab(),
        ],
      ),
    );
  }

  Widget _buildMoodTrackingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How are you feeling today?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildMoodSelector(),
          const SizedBox(height: 30),
          const Text(
            'What factors are affecting your mood?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildFactorSelector(),
          const SizedBox(height: 30),
          const Text(
            'Notes (optional)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'How are you feeling? What happened today?',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 30),
          Consumer<MoodProvider>(
            builder: (context, moodProvider, child) {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedMood != null && !moodProvider.isLoading
                      ? () => _saveMoodEntry(moodProvider)
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: moodProvider.isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Save Entry',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          _buildTodaysSummary(),
        ],
      ),
    );
  }

  Widget _buildMoodSelector() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: MoodType.values.map((mood) {
        return _buildMoodButton(mood);
      }).toList(),
    );
  }

  Widget _buildMoodButton(MoodType mood) {
    final isSelected = _selectedMood == mood;
    return GestureDetector(
      onTap: () => setState(() => _selectedMood = mood),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? mood.color.withOpacity(0.2) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? mood.color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(mood.emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(
              mood.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? mood.color : Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFactorSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: moodFactors.map((factor) {
        final isSelected = _selectedFactors.contains(factor);
        return ChoiceChip(
          label: Text(factor),
          selected: isSelected,
          onSelected: (selected) => setState(() {
            if (selected) {
              _selectedFactors.add(factor);
            } else {
              _selectedFactors.remove(factor);
            }
          }),
          selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
          labelStyle: TextStyle(
            color: isSelected 
                ? Theme.of(context).primaryColor 
                : Colors.grey[800],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTodaysSummary() {
    return Consumer<MoodProvider>(
      builder: (context, moodProvider, child) {
        final todaysEntries = moodProvider.getTodayMoodEntries();
        
        if (todaysEntries.isEmpty) {
          return const SizedBox.shrink();
        }

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Today\'s Mood Entries',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...todaysEntries.map((entry) => 
                  _buildMoodEntryItem(entry)).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMoodEntryItem(MoodEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: entry.mood.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: entry.mood.color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Text(entry.mood.emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.mood.label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat('HH:mm').format(entry.timestamp),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                if (entry.notes?.isNotEmpty == true) ...[
                  const SizedBox(height: 4),
                  Text(
                    entry.notes!,
                    style: TextStyle(color: Colors.grey[700]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 20),
            onPressed: () => _showDeleteConfirmation(entry),
            color: Colors.grey[500],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return Consumer<MoodProvider>(
      builder: (context, moodProvider, child) {
        if (moodProvider.isLoading && moodProvider.moodEntries.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (moodProvider.moodEntries.isEmpty) {
          return _buildEmptyState(
            icon: Icons.mood_outlined,
            title: 'No mood entries yet',
            message: 'Start tracking your mood to see history',
          );
        }

        return RefreshIndicator(
          onRefresh: () => moodProvider.initialize(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: moodProvider.moodEntries.length,
            itemBuilder: (context, index) {
              final entry = moodProvider.moodEntries[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: entry.mood.color.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        entry.mood.emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  title: Text(
                    entry.mood.label,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('MMM d, y • h:mm a').format(entry.timestamp),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      if (entry.notes?.isNotEmpty == true) ...[
                        const SizedBox(height: 4),
                        Text(
                          entry.notes!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (entry.factors.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: entry.factors.map((factor) {
                            return Chip(
                              label: Text(factor),
                              backgroundColor: Colors.grey[200],
                              labelStyle: const TextStyle(fontSize: 12),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _showDeleteConfirmation(entry),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAnalyticsTab() {
    return Consumer<MoodProvider>(
      builder: (context, moodProvider, child) {
        if (moodProvider.isLoading && moodProvider.moodEntries.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (moodProvider.moodEntries.isEmpty) {
          return _buildEmptyState(
            icon: Icons.analytics_outlined,
            title: 'No analytics available',
            message: 'Track your mood for a few days to see insights',
          );
        }

        return RefreshIndicator(
          onRefresh: () => moodProvider.initialize(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildMoodChart(moodProvider),
                const SizedBox(height: 20),
                _buildMoodDistribution(moodProvider),
                const SizedBox(height: 20),
                _buildCommonFactors(moodProvider),
                const SizedBox(height: 20),
                _buildStreakWidget(moodProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMoodChart(MoodProvider moodProvider) {
    final weeklyEntries = moodProvider.getWeekMoodEntries();
    
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Mood Trend',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              days[value.toInt() % 7],
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: MoodType.values.length.toDouble(),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _generateMoodSpots(weeklyEntries),
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _generateMoodSpots(List<MoodEntry> entries) {
    final spots = <FlSpot>[];
    final now = DateTime.now();
    
    for (int i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: 6 - i));
      final dayEntries = entries.where((entry) =>
          entry.timestamp.year == date.year &&
          entry.timestamp.month == date.month &&
          entry.timestamp.day == date.day).toList();
      
      if (dayEntries.isNotEmpty) {
        final averageMood = dayEntries.fold<double>(
          0, 
          (sum, entry) => sum + entry.mood.value
        ) / dayEntries.length;
        spots.add(FlSpot(i.toDouble(), averageMood));
      } else {
        // Add empty spot if no entries for that day
        spots.add(FlSpot(i.toDouble(), 0));
      }
    }
    
    return spots;
  }

  Widget _buildMoodDistribution(MoodProvider moodProvider) {
    final distribution = moodProvider.getMoodDistribution();
    
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mood Distribution',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...MoodType.values.map((mood) {
              final count = distribution[mood] ?? 0;
              if (count == 0) return const SizedBox.shrink();
              return _buildDistributionItem(mood, count);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionItem(MoodType mood, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: mood.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(mood.emoji, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mood.label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: count / _calculateMaxCount(),
                  backgroundColor: Colors.grey[200],
                  color: mood.color,
                  minHeight: 6,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$count',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: mood.color,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateMaxCount() {
    final moodProvider = Provider.of<MoodProvider>(context, listen: false);
    final distribution = moodProvider.getMoodDistribution();
    if (distribution.isEmpty) return 1;
    return distribution.values.reduce((a, b) => a > b ? a : b).toDouble();
  }

  Widget _buildCommonFactors(MoodProvider moodProvider) {
    final factors = moodProvider.getMostCommonFactors();
    
    if (factors.isEmpty) return const SizedBox.shrink();

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Most Common Factors',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: factors.entries.map((entry) {
                return Chip(
                  label: Text('${entry.key} (${entry.value})'),
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakWidget(MoodProvider moodProvider) {
    final streak = moodProvider.getMoodStreak();
    
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.local_fire_department, 
                color: Colors.orange, size: 32),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Streak',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '$streak day${streak != 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Future<void> _saveMoodEntry(MoodProvider moodProvider) async {
    try {
      await moodProvider.addMoodEntry(
        MoodEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          mood: _selectedMood!,
          timestamp: DateTime.now(),
          notes: _notesController.text.trim().isEmpty 
              ? null 
              : _notesController.text.trim(),
          factors: List.from(_selectedFactors), userId: '',
        ),
      );

      // Reset form
      setState(() {
        _selectedMood = null;
        _selectedFactors.clear();
        _notesController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Mood entry saved!'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDeleteConfirmation(MoodEntry entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text('Are you sure you want to delete this mood entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await Provider.of<MoodProvider>(context, listen: false)
                    .deleteMoodEntry(entry.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Entry deleted'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to delete: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}