class CreateTodoDto {
  final String title;
  final bool forMe;

  CreateTodoDto({required this.title, required this.forMe});

  Map<String, dynamic> toJson() {
    return {'title': title, 'forMe': forMe};
  }

  factory CreateTodoDto.fromJson(Map<String, dynamic> json) {
    return CreateTodoDto(
      title: json['title'] as String,
      forMe: json['forMe'] as bool,
    );
  }
}
