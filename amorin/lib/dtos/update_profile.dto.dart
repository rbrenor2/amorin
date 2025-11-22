class UpdateProfileDto {
  final String name;
  final int age;
  final String? careRecipientName;
  final int? careRecipientAge;
  final String? relationship;
  final String? conditions;
  final String? careDuration;
  final String? supportSystem;
  final String? challenges;

  UpdateProfileDto({
    required this.name,
    required this.age,
    this.careRecipientName,
    this.careRecipientAge,
    this.relationship,
    this.conditions,
    this.careDuration,
    this.supportSystem,
    this.challenges,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'careRecipientName': careRecipientName,
      'careRecipientAge': careRecipientAge,
      'relationship': relationship,
      'conditions': conditions,
      'careDuration': careDuration,
      'supportSystem': supportSystem,
      'challenges': challenges,
    };
  }

  factory UpdateProfileDto.fromJson(Map<String, dynamic> json) {
    return UpdateProfileDto(
      name: json['name'] as String,
      age: json['age'] as int,
      careRecipientName: json['careRecipientName'] as String?,
      careRecipientAge: json['careRecipientAge'] as int?,
      relationship: json['relationship'] as String?,
      conditions: json['conditions'] as String?,
      careDuration: json['careDuration'] as String?,
      supportSystem: json['supportSystem'] as String?,
      challenges: json['challenges'] as String?,
    );
  }
}
