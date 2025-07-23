import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CounsellorMatchingScreen extends StatefulWidget {
  const CounsellorMatchingScreen({super.key});

  @override
  State<CounsellorMatchingScreen> createState() => _CounsellorMatchingScreenState();
}

class _CounsellorMatchingScreenState extends State<CounsellorMatchingScreen> {
  String _selectedSpecialty = 'All';
  bool _isAvailableNow = false;

  final List<String> _specialties = [
    'All',
    'Anxiety',
    'Depression',
    'Relationships',
    'Stress Management',
    'Trauma',
    'Addiction',
    'Family Therapy',
    'Career Counseling',
  ];

  final List<Counsellor> _counsellors = [
    Counsellor(
      id: '1',
      name: 'Dr. Sarah Johnson',
      specialty: 'Anxiety & Depression',
      rating: 4.9,
      reviewCount: 127,
      isAvailable: true,
      pricePerSession: 80,
      experience: '8 years',
      image: 'assets/images/counsellor1.jpg',
      bio: 'Specializes in cognitive behavioral therapy and mindfulness techniques.',
      qualifications: ['Ph.D. in Clinical Psychology', 'Licensed Clinical Psychologist'],
    ),
    Counsellor(
      id: '2',
      name: 'Michael Chen',
      specialty: 'Relationship Counseling',
      rating: 4.8,
      reviewCount: 95,
      isAvailable: false,
      pricePerSession: 75,
      experience: '6 years',
      image: 'assets/images/counsellor2.jpg',
      bio: 'Helps couples and individuals navigate relationship challenges.',
      qualifications: ['M.A. in Marriage & Family Therapy', 'Licensed Marriage Counselor'],
    ),
    Counsellor(
      id: '3',
      name: 'Dr. Emily Rodriguez',
      specialty: 'Stress & Trauma',
      rating: 4.9,
      reviewCount: 156,
      isAvailable: true,
      pricePerSession: 90,
      experience: '12 years',
      image: 'assets/images/counsellor3.jpg',
      bio: 'Expert in EMDR and trauma-focused therapy approaches.',
      qualifications: ['Ph.D. in Counseling Psychology', 'EMDR Certified'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Counsellor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: _buildCounsellorsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search counsellors...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedSpecialty,
                  decoration: const InputDecoration(
                    labelText: 'Specialty',
                    border: OutlineInputBorder(),
                  ),
                  items: _specialties.map((specialty) {
                    return DropdownMenuItem(
                      value: specialty,
                      child: Text(specialty),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSpecialty = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              FilterChip(
                label: const Text('Available Now'),
                selected: _isAvailableNow,
                onSelected: (selected) {
                  setState(() {
                    _isAvailableNow = selected;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCounsellorsList() {
    final filteredCounsellors = _counsellors.where((counsellor) {
      if (_selectedSpecialty != 'All' && !counsellor.specialty.contains(_selectedSpecialty)) {
        return false;
      }
      if (_isAvailableNow && !counsellor.isAvailable) {
        return false;
      }
      return true;
    }).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredCounsellors.length,
      itemBuilder: (context, index) {
        final counsellor = filteredCounsellors[index];
        return _buildCounsellorCard(counsellor);
      },
    );
  }

  Widget _buildCounsellorCard(Counsellor counsellor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            counsellor.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (counsellor.isAvailable)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Available',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Text(
                        counsellor.specialty,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${counsellor.rating}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' (${counsellor.reviewCount} reviews)',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${counsellor.pricePerSession}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A90E2),
                      ),
                    ),
                    const Text(
                      'per session',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              counsellor.bio,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.work_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${counsellor.experience} experience',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showCounsellorProfile(counsellor),
                    icon: const Icon(Icons.info_outline),
                    label: const Text('View Profile'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: counsellor.isAvailable
                        ? () => _bookSession(counsellor)
                        : null,
                    icon: const Icon(Icons.video_call),
                    label: const Text('Book Session'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Counsellors'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('Available Now'),
              value: _isAvailableNow,
              onChanged: (value) {
                setState(() {
                  _isAvailableNow = value!;
                });
              },
            ),
            // Add more filter options here
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showCounsellorProfile(Counsellor counsellor) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          counsellor.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          counsellor.specialty,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'About',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(counsellor.bio),
              const SizedBox(height: 16),
              Text(
                'Qualifications',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...counsellor.qualifications.map((qualification) => 
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 16),
                      const SizedBox(width: 8),
                      Expanded(child: Text(qualification)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _bookSession(counsellor);
                  },
                  child: const Text('Book Session'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _bookSession(Counsellor counsellor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Book Session with ${counsellor.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Session Fee: \$${counsellor.pricePerSession}'),
            const SizedBox(height: 8),
            const Text('Available Time Slots:'),
            const SizedBox(height: 8),
            ...['Today 2:00 PM', 'Today 4:00 PM', 'Tomorrow 10:00 AM'].map(
              (slot) => ListTile(
                title: Text(slot),
                leading: Radio(
                  value: slot,
                  groupValue: null,
                  onChanged: (value) {},
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Session booked with ${counsellor.name}'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Book Now'),
          ),
        ],
      ),
    );
  }
}

class Counsellor {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final int reviewCount;
  final bool isAvailable;
  final int pricePerSession;
  final String experience;
  final String image;
  final String bio;
  final List<String> qualifications;

  Counsellor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviewCount,
    required this.isAvailable,
    required this.pricePerSession,
    required this.experience,
    required this.image,
    required this.bio,
    required this.qualifications,
  });
}

