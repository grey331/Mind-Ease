import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animations/animations.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'auth_screen.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildHeroSection(),
            _buildFeaturesSection(),
            _buildHowItWorksSection(),
            _buildPricingSection(),
            _buildTestimonialsSection(),
            _buildCallToActionSection(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.psychology,
                size: 32,
                color: Color(0xFF4A90E2),
              ),
              const SizedBox(width: 8),
              Text(
                'MindEase',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          Row(
            children: [
              TextButton(
                onPressed: () => _scrollToSection(1),
                child: const Text('Features'),
              ),
              TextButton(
                onPressed: () => _scrollToSection(2),
                child: const Text('How it Works'),
              ),
              TextButton(
                onPressed: () => _scrollToSection(3),
                child: const Text('Pricing'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () => _showAuthDialog(context),
                child: const Text('Get Started'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Text(
            'AI-Powered Emotional Support &\nCounsellor Connection',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
              height: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '24/7 Mental Health Support • Licensed Counsellors • Mood Tracking',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => _showAuthDialog(context),
                icon: const Icon(Icons.chat),
                label: const Text('Start Free Chat'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(width: 20),
              OutlinedButton.icon(
                onPressed: () => _scrollToSection(1),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Watch Demo'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          _buildStatsSection(),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('1 in 4', 'People globally suffer from\nmental health issues'),
          _buildStatItem('24/7', 'AI-powered emotional\nsupport available'),
          _buildStatItem('100', 'Licensed counsellors\nready to help'),
          _buildStatItem('95%', 'User satisfaction\nrating'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String number, String description) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A90E2),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Text(
            'Why Choose MindEase?',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 40),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 30,
            crossAxisSpacing: 30,
            children: [
              _buildFeatureCard(
                FontAwesomeIcons.robot,
                'AI-Driven Support',
                'Get instant emotional support and coping techniques powered by advanced AI',
              ),
              _buildFeatureCard(
                FontAwesomeIcons.userDoctor,
                'Licensed Counsellors',
                'Connect with verified mental health professionals via secure chat/video',
              ),
              _buildFeatureCard(
                FontAwesomeIcons.chartLine,
                'Mood Tracking',
                'Track your mood patterns and receive personalized wellness insights',
              ),
              _buildFeatureCard(
                FontAwesomeIcons.shield,
                'Privacy First',
                'HIPAA/GDPR compliant with end-to-end encryption for your safety',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              size: 48,
              color: const Color(0xFF4A90E2),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHowItWorksSection() {
    return Container(
      padding: const EdgeInsets.all(40),
      color: const Color(0xFFF8F9FA),
      child: Column(
        children: [
          Text(
            'How MindEase Works',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStepCard(
                '1',
                'Chat with AI',
                'Start a conversation with our AI companion for immediate support',
                FontAwesomeIcons.comments,
              ),
              _buildStepCard(
                '2',
                'Get Matched',
                'Seamlessly connect with licensed counsellors when you need human support',
                FontAwesomeIcons.handshake,
              ),
              _buildStepCard(
                '3',
                'Track Progress',
                'Monitor your mental health journey with mood tracking and insights',
                FontAwesomeIcons.chartBar,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard(String number, String title, String description, IconData icon) {
    return SizedBox(
      width: 300,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFF4A90E2),
                child: Text(
                  number,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FaIcon(
                icon,
                size: 32,
                color: const Color(0xFF4A90E2),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPricingSection() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Text(
            'Choose Your Plan',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPricingCard(
                'Free',
                '\$0',
                'per month',
                [
                  'Basic AI chatbot support',
                  'Self-help resources',
                  'Community forums',
                  'Basic mood tracking',
                ],
                false,
              ),
              const SizedBox(width: 40),
              _buildPricingCard(
                'Premium',
                '\$9.99',
                'per month',
                [
                  'Unlimited AI support',
                  'Licensed counsellor access',
                  'Advanced mood analytics',
                  'Crisis support',
                  'Priority customer service',
                ],
                true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard(String title, String price, String period, List<String> features, bool isPopular) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPopular ? const Color(0xFF4A90E2) : Colors.grey[300]!,
          width: isPopular ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          if (isPopular)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFF4A90E2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: const Center(
                child: Text(
                  'MOST POPULAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A90E2),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      period,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ...features.map((feature) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check,
                        color: Color(0xFF4A90E2),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                )).toList(),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showAuthDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPopular ? const Color(0xFF4A90E2) : Colors.grey[300],
                      foregroundColor: isPopular ? Colors.white : Colors.grey[700],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(title == 'Free' ? 'Get Started' : 'Start Free Trial'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialsSection() {
    return Container(
      padding: const EdgeInsets.all(40),
      color: const Color(0xFFF8F9FA),
      child: Column(
        children: [
          Text(
            'What Our Users Say',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTestimonialCard(
                'Sarah M.',
                'College Student',
                'MindEase helped me through my anxiety during finals week. The AI was so understanding and connected me with a great counsellor.',
                5,
              ),
              _buildTestimonialCard(
                'Mike R.',
                'Software Engineer',
                'The mood tracking feature helped me identify patterns in my mental health. It\'s been a game-changer for my self-awareness.',
                5,
              ),
              _buildTestimonialCard(
                'Emily K.',
                'Marketing Manager',
                'Having 24/7 support available has been incredible. I can reach out whenever I need help, and the counsellors are amazing.',
                5,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard(String name, String role, String testimonial, int rating) {
    return SizedBox(
      width: 300,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(
                  rating,
                  (index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '"$testimonial"',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                role,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCallToActionSection() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Text(
            'Ready to Start Your Mental Health Journey?',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            'Join thousands of users who have found support and healing with MindEase.',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => _showAuthDialog(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
              textStyle: const TextStyle(fontSize: 20),
            ),
            child: const Text('Get Started Free'),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(40),
      color: Colors.grey[800],
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.psychology,
                        size: 24,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'MindEase',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'AI-Powered Mental Health Support',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Links',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildFooterLink('About Us'),
                  _buildFooterLink('Privacy Policy'),
                  _buildFooterLink('Terms of Service'),
                  _buildFooterLink('Contact Support'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Crisis Support',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildFooterLink('Suicide Prevention: 988'),
                  _buildFooterLink('Crisis Text Line: 741741'),
                  _buildFooterLink('NAMI: 1-800-950-6264'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Divider(color: Colors.white24),
          const SizedBox(height: 20),
          const Text(
            '© 2024 MindEase. All rights reserved. • Making mental health support accessible to all.',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 12,
        ),
      ),
    );
  }

  void _scrollToSection(int section) {
    // Implement smooth scrolling to sections
    // This would require using a ScrollController
  }

  void _showAuthDialog(BuildContext context) {
    showModal(
      context: context,
      builder: (context) => const AuthScreen(),
    );
  }
}

