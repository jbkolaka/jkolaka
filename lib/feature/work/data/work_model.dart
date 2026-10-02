class WorkExperience {
  final int id;
  final int year;
  final String company;
  final String role;
  final String url;

  const WorkExperience({
    required this.id,
    required this.year,
    required this.company,
    required this.role,
    this.url = '',
  });

  // Decodes a JSON map into a WorkExperience instance
  factory WorkExperience.fromJson(Map<String, dynamic> json) {
    return WorkExperience(
      id: json['id'] as int,
      year: json['year'] as int,
      company: json['company'] as String,
      role: json['role'] as String,
      url: json['url'] as String? ?? '',
    );
  }

  // Encodes a WorkExperience instance into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'year': year,
      'company': company,
      'role': role,
      'url': url,
    };
  }

  // Safely creates a copy of the object with modified values
  WorkExperience copyWith({
    int? id,
    int? year,
    String? company,
    String? role,
    String? url,
  }) {
    return WorkExperience(
      id: id ?? this.id,
      year: year ?? this.year,
      company: company ?? this.company,
      role: role ?? this.role,
      url: url ?? this.url,
    );
  }

  @override
  String toString() {
    return 'WorkExperience(id: $id, year: $year, company: $company, role: $role, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WorkExperience &&
        other.id == id &&
        other.year == year &&
        other.company == company &&
        other.role == role &&
        other.url == url;
  }

  @override
  int get hashCode {
    return id.hashCode ^ year.hashCode ^ company.hashCode ^ role.hashCode ^ url.hashCode;
  }
}
