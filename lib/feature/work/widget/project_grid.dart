import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../theme/spacing/app_spacing.dart';
import '../data/project_model.dart';
import 'circle_pointer.dart';

/// Project cards styled after Rachel Chen's portfolio — cover image, then a
/// title and a "Company • Tagline • Year" subtitle. Hovering the cover shows
/// a light scrim and expands the cursor into a "View Project" pill.
class ProjectGrid extends StatefulWidget {
  const ProjectGrid({super.key});

  @override
  State<ProjectGrid> createState() => _ProjectGridState();
}

class _ProjectGridState extends State<ProjectGrid> {
  List<Project>? _projects;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final String raw = await rootBundle.loadString(
      'lib/feature/work/data/projects.json',
    );
    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
    final List<Project> projects = decoded
        .map((e) => Project.fromJson(e as Map<String, dynamic>))
        .toList();
    setState(() => _projects = projects);
  }

  @override
  Widget build(BuildContext context) {
    final List<Project>? projects = _projects;
    if (projects == null) {
      return const SizedBox.shrink();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.spacing07,
        crossAxisSpacing: AppSpacing.spacing07,
        childAspectRatio: 1.15,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) => _ProjectCard(project: projects[index]),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  const _ProjectCard({required this.project});

  final Project project;

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return MouseRegion(
      onEnter: (_) {
        setState(() => _hovered = true);
        cursorLabel.value = 'View Project';
      },
      onExit: (_) {
        setState(() => _hovered = false);
        cursorLabel.value = null;
      },
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, widget.project.route),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: scheme.outlineVariant),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(widget.project.image, fit: BoxFit.cover),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      opacity: _hovered ? 1 : 0,
                      child: ColoredBox(
                        color: scheme.surface.withValues(alpha: 0.45),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.spacing04),
            Text(
              widget.project.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 17,
                height: 1.3,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.spacing01),
            Text(
              widget.project.subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                height: 1.3,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}