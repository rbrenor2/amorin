import 'package:amorin/dtos/create_todo.dto.dart';
import 'package:amorin/dtos/update_profile.dto.dart';
import 'package:amorin/services/profile.service.dart';
import 'package:amorin/services/todo.service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseRepository implements ProfileRepository, TodoRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> updateProfile(UpdateProfileDto profileData) async {
    await _firestore
        .collection('profiles')
        .doc('rbrenorios@gmail.com')
        .set(profileData.toJson());
  }

  @override
  Future<void> createTodo(CreateTodoDto todo) async {
    await _firestore
        .collection('profiles')
        .doc('rbrenorios@gmail.com')
        .collection('todos')
        .add({
          ...todo.toJson(),
          'completed': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
  }

  @override
  Future<List<Map<String, dynamic>>> getTodos() async {
    final snapshot = await _firestore
        .collection('profiles')
        .doc('rbrenorios@gmail.com')
        .collection('todos')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'name': data['title'] ?? '',
        'forMe': data['forMe'] ?? false,
        'completed': data['completed'] ?? false,
      };
    }).toList();
  }

  @override
  Future<void> deleteTodo(String todoId) async {
    await _firestore
        .collection('profiles')
        .doc('rbrenorios@gmail.com')
        .collection('todos')
        .doc(todoId)
        .delete();
  }

  @override
  Future<void> updateTodo(String todoId, Map<String, dynamic> updates) async {
    await _firestore
        .collection('profiles')
        .doc('rbrenorios@gmail.com')
        .collection('todos')
        .doc(todoId)
        .update(updates);
  }
}
