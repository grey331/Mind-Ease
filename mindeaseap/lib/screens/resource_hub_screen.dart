import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ResourceHubScreen extends StatelessWidget {
  const ResourceHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resource Hub'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mental Health Resources',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildEmergencyCard(),
            const SizedBox(height: 20),
            _buildResourceCategories(),
            const SizedBox(height: 20),
            _buildArticlesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyCard() {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(
              Icons.emergency,
              color: Colors.red,
              size: 40,
            ),
            const SizedBox(height: 12),
            const Text(
              'Crisis Support',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'If you\'re having thoughts of self-harm or suicide, please reach out immediately:',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.phone),
                  label: const Text('Call 988'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.message),
                  label: const Text('Text 741741'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceCategories() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildCategoryCard(
          'Breathing Exercises',
          FontAwesomeIcons.lungs,
          Colors.blue,
          'Learn breathing techniques for anxiety and stress',
        ),
        _buildCategoryCard(
          'Mindfulness',
          FontAwesomeIcons.brain,
          Colors.green,
          'Guided meditation and mindfulness practices',
        ),
        _buildCategoryCard(
          'Sleep Support',
          FontAwesomeIcons.bed,
          Colors.purple,
          'Tips and techniques for better sleep',
        ),
        _buildCategoryCard(
          'Stress Management',
          FontAwesomeIcons.shield,
          Colors.orange,
          'Effective strategies for managing stress',
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, Color color, String description) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticlesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Articles',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildArticleItem(
          'Understanding Anxiety: Signs and Symptoms',
          'Learn to recognize the signs of anxiety and when to seek help.',
          'Dr. Sarah Johnson',
          '5 min read',
        ),
        _buildArticleItem(
          'The Power of Positive Thinking',
          'Discover how positive thinking can impact your mental health.',
          'Michael Chen',
          '7 min read',
        ),
        _buildArticleItem(
          'Building Resilience in Difficult Times',
          'Strategies for developing emotional resilience and coping skills.',
          'Dr. Emily Rodriguez',
          '6 min read',
        ),
      ],
    );
  }

  Widget _buildArticleItem(String title, String description, String author, String readTime) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF4A90E2).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.article,
            color: Color(0xFF4A90E2),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 4),
            Text(
              '$author • $readTime',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Navigate to article detail
        },
      ),
    );
  }
}

