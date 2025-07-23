import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/mood_provider.dart';
import '../providers/chat_provider.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Mental Health Journey',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildProgressCards(),
            const SizedBox(height: 20),
            _buildWeeklyProgress(),
            const SizedBox(height: 20),
            _buildGoalsSection(),
            const SizedBox(height: 20),
            _buildAchievements(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCards() {
    return Consumer2<MoodProvider, ChatProvider>(
      builder: (context, moodProvider, chatProvider, child) {
        final moodEntries = moodProvider.moodEntries;
        final chatMessages = chatProvider.messages;

        return Row(
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(Icons.mood, size: 40, color: Color(0xFF4A90E2)),
                      const SizedBox(height: 8),
                      Text(
                        '${moodEntries.length}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('Mood Entries'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(Icons.chat, size: 40, color: Color(0xFF4A90E2)),
                      const SizedBox(height: 8),
                      Text(
                        '${chatMessages.length}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('Chat Messages'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWeeklyProgress() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 3),
                        FlSpot(1, 4),
                        FlSpot(2, 3.5),
                        FlSpot(3, 5),
                        FlSpot(4, 4.5),
                        FlSpot(5, 6),
                        FlSpot(6, 6.5),
                      ],
                      isCurved: true,
                      color: const Color(0xFF4A90E2),
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xFF4A90E2).withOpacity(0.1),
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

  Widget _buildGoalsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Goals',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildGoalItem('Daily mood tracking', 0.8),
            _buildGoalItem('Weekly chat sessions', 0.6),
            _buildGoalItem('Mindfulness practice', 0.4),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalItem(String title, double progress) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
          ),
          const SizedBox(height: 4),
          Text(
            '${(progress * 100).toInt()}% complete',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Achievements',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildAchievementBadge('First Chat', Icons.chat, Colors.blue),
                const SizedBox(width: 16),
                _buildAchievementBadge('Week Streak', Icons.calendar_today, Colors.green),
                const SizedBox(width: 16),
                _buildAchievementBadge('Mood Master', Icons.mood, Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementBadge(String title, IconData icon, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

