import 'package:amorin/dtos/update_profile.dto.dart';
import 'package:amorin/services/profile.service.dart';
import 'package:amorin/repositories/firebase.repository.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UpdateProfileDto? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profileService = ProfileService(FirebaseRepository());
      final profile = await profileService.getProfile();
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load profile: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _profile == null
          ? const Center(child: Text('No profile found'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          child: Text(
                            _profile!.name[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _profile!.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'rbrenorios@gmail.com',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_profile!.age} years old',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (_profile!.careRecipientName != null) ...[
                    _buildSectionTitle('Care Information'),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      icon: Icons.person_outline,
                      label: 'Care Recipient',
                      value: _profile!.careRecipientName!,
                    ),
                    if (_profile!.careRecipientAge != null)
                      _buildInfoCard(
                        icon: Icons.cake_outlined,
                        label: 'Age',
                        value: '${_profile!.careRecipientAge} years old',
                      ),
                    if (_profile!.relationship != null)
                      _buildInfoCard(
                        icon: Icons.favorite_outline,
                        label: 'Relationship',
                        value: _profile!.relationship!,
                      ),
                    if (_profile!.conditions != null)
                      _buildInfoCard(
                        icon: Icons.medical_information_outlined,
                        label: 'Conditions/Disabilities',
                        value: _profile!.conditions!,
                        multiline: true,
                      ),
                    if (_profile!.careDuration != null)
                      _buildInfoCard(
                        icon: Icons.access_time,
                        label: 'Duration of Care',
                        value: _profile!.careDuration!,
                      ),
                    const SizedBox(height: 24),
                  ],
                  if (_profile!.supportSystem != null ||
                      _profile!.challenges != null) ...[
                    _buildSectionTitle('Support & Challenges'),
                    const SizedBox(height: 12),
                    if (_profile!.supportSystem != null)
                      _buildInfoCard(
                        icon: Icons.people_outline,
                        label: 'Support System',
                        value: _profile!.supportSystem!,
                        multiline: true,
                      ),
                    if (_profile!.challenges != null)
                      _buildInfoCard(
                        icon: Icons.warning_amber_outlined,
                        label: 'Main Challenges',
                        value: _profile!.challenges!,
                        multiline: true,
                      ),
                  ],
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    bool multiline = false,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: multiline
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 15, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
