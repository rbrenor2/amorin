import 'package:amorin/dtos/update_profile.dto.dart';
import 'package:amorin/services/profile.service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseRepository implements ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> updateProfile(UpdateProfileDto profileData) async {
    await _firestore
        .collection('profiles')
        .doc('rbrenorios@gmail.com')
        .set(profileData.toJson());
  }
}
