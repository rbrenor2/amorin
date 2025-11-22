import 'package:amorin/dtos/update_profile.dto.dart';
import 'package:amorin/repositories/firebase.repository.dart';

abstract class ProfileRepository {
  Future<void> updateProfile(UpdateProfileDto profileData);
  Future<UpdateProfileDto?> getProfile();
}

class ProfileService {
  final ProfileRepository repository;

  ProfileService(this.repository);

  Future<void> updateProfile(UpdateProfileDto profileData) async {
    await repository.updateProfile(profileData);
  }

  Future<UpdateProfileDto?> getProfile() async {
    return await repository.getProfile();
  }
}
