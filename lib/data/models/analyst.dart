class Analyst {
  const Analyst({
    required this.name,
    required this.role,
    this.avatarUrl,
  });

  final String name;
  final String role;
  final String? avatarUrl;

  factory Analyst.fromJson(Map<String, dynamic> json) {
    return Analyst(
      name: json['name'] as String,
      role: json['role'] as String,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'role': role,
        'avatar_url': avatarUrl,
      };
}
