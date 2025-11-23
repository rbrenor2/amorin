import 'package:amorin/repositories/firebase.repository.dart';
import 'package:flutter/material.dart';
import 'package:amorin/pages/main.page.dart';
import 'package:amorin/dtos/update_profile.dto.dart';
import 'package:amorin/services/profile.service.dart';

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({super.key});

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final careRecipientNameController = TextEditingController();
  final careRecipientAgeController = TextEditingController();
  final relationshipController = TextEditingController();
  final conditionsController = TextEditingController();
  final careDurationController = TextEditingController();
  final supportSystemController = TextEditingController();
  final challengesController = TextEditingController();

  final ProfileService profileService = ProfileService(FirebaseRepository());

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    careRecipientNameController.dispose();
    careRecipientAgeController.dispose();
    relationshipController.dispose();
    conditionsController.dispose();
    careDurationController.dispose();
    supportSystemController.dispose();
    challengesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Let\'s get to know you'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'About You',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Help us understand your caregiving journey',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'What is your name?',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: ageController,
                  decoration: const InputDecoration(
                    labelText: 'How old are you?',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                const Text(
                  'About Your Loved One',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: careRecipientNameController,
                  decoration: const InputDecoration(
                    labelText: 'What is their name? (optional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.favorite),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: careRecipientAgeController,
                  decoration: const InputDecoration(
                    labelText: 'How old are they?',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.cake),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: relationshipController,
                  decoration: const InputDecoration(
                    labelText: 'What is your relationship to them?',
                    hintText: 'e.g., parent, spouse, child, friend',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.people),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: conditionsController,
                  decoration: const InputDecoration(
                    labelText: 'What conditions or challenges do they face?',
                    hintText:
                        'e.g., Alzheimer\'s, mobility issues, chronic illness',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.medical_services),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 32),

                const Text(
                  'Your Caregiving Experience',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: careDurationController,
                  decoration: const InputDecoration(
                    labelText: 'How long have you been caregiving?',
                    hintText: 'e.g., 2 years, 6 months',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.schedule),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: supportSystemController,
                  decoration: const InputDecoration(
                    labelText: 'Do you have support from family or friends?',
                    hintText: 'Tell us about your support system',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.group),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: challengesController,
                  decoration: const InputDecoration(
                    labelText:
                        'What\'s the hardest part of caregiving for you?',
                    hintText: 'Share your biggest challenges',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.psychology),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final profileData = UpdateProfileDto(
                          name: nameController.text,
                          age: int.parse(ageController.text),
                          careRecipientName:
                              careRecipientNameController.text.isEmpty
                              ? null
                              : careRecipientNameController.text,
                          careRecipientAge:
                              careRecipientAgeController.text.isEmpty
                              ? null
                              : int.tryParse(careRecipientAgeController.text),
                          relationship: relationshipController.text.isEmpty
                              ? null
                              : relationshipController.text,
                          conditions: conditionsController.text.isEmpty
                              ? null
                              : conditionsController.text,
                          careDuration: careDurationController.text.isEmpty
                              ? null
                              : careDurationController.text,
                          supportSystem: supportSystemController.text.isEmpty
                              ? null
                              : supportSystemController.text,
                          challenges: challengesController.text.isEmpty
                              ? null
                              : challengesController.text,
                        );

                        await profileService.updateProfile(profileData);

                        if (context.mounted) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const MainPage(),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
