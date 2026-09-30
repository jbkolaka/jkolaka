class Project {
  const Project({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.route,
  });

  final String id;
  final String title;
  final String subtitle;
  final String image;
  final String route;

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      image: json['image'] as String,
      route: json['route'] as String,
    );
  }
}