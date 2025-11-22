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
}
