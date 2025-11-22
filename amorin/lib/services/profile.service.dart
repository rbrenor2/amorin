import 'package:amorin/dtos/update_profile.dto.dart';
import 'package:amorin/repositories/firebase.repository.dart';

abstract class ProfileRepository {
  Future<void> updateProfile(UpdateProfileDto profileData);
}

class ProfileService {
  final ProfileRepository repository = FirebaseRepository();

  Future<void> updateProfile(UpdateProfileDto profileData) async {
    await repository.updateProfile(profileData);
  }
}
