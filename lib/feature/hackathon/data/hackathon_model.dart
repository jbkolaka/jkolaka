class HackathonProject {
  final String id;
  final String title;
  final String subtitle;
  final String image;
  final String label;

  const HackathonProject({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.label,
  });

  factory HackathonProject.fromJson(Map<String, dynamic> json) {
    return HackathonProject(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      image: json['image'] as String,
      label: json['label'] as String,
    );
  }
}