import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../theme/spacing/app_spacing.dart';
import '../../../theme/typography/app_typography.dart';
import '../data/hackathon_model.dart';
import '../../work/widget/circle_pointer.dart';

/// Hackathon cards: a full-bleed cover with a hairline border, then a 17px
/// title and a 15px "name • credential" line. Hovering darkens the cover and
/// expands the cursor into the card's label pill.
class HackathonGrid extends StatefulWidget {
  const HackathonGrid({super.key});

  @override
  State<HackathonGrid> createState() => _HackathonGridState();
}

class _HackathonGridState extends State<HackathonGrid> {
  List<HackathonProject>? _projects;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final String raw = await rootBundle.loadString(
      'lib/feature/hackathon/data/hackathons.json',
    );
    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
    final List<HackathonProject> projects = decoded
        .map((e) => HackathonProject.fromJson(e as Map<String, dynamic>))
        .toList();
    setState(() => _projects = projects);
  }

  @override
  Widget build(BuildContext context) {
    final List<HackathonProject>? projects = _projects;
    if (projects == null) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final int columns = _columnsFor(width);
        final double cellWidth =
            (width - AppSpacing.spacing06 * (columns - 1)) / columns;
        final double textBlockHeight = 96;
        final double aspect =
            cellWidth / (cellWidth * 9 / 16 + textBlockHeight);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: AppSpacing.spacing06,
            crossAxisSpacing: AppSpacing.spacing06,
            childAspectRatio: aspect,
          ),
          itemCount: projects.length,
          itemBuilder: (context, index) =>
              _HackathonCard(project: projects[index]),
        );
      },
    );
  }

  int _columnsFor(double width) {
    if (width >= 1024) return 3;
    if (width >= 768) return 2;
    return 1;
  }
}

class _HackathonCard extends StatefulWidget {
  const _HackathonCard({required this.project});

  final HackathonProject project;

  @override
  State<_HackathonCard> createState() => _HackathonCardState();
}

class _HackathonCardState extends State<_HackathonCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return MouseRegion(
      onEnter: (_) {
        setState(() => _hovered = true);
        cursorLabel.value = widget.project.label;
      },
      onExit: (_) {
        setState(() => _hovered = false);
        cursorLabel.value = null;
      },
      child: GestureDetector(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  border: Border.all(color: scheme.outlineVariant),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(widget.project.image, fit: BoxFit.cover),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      opacity: _hovered ? 1 : 0,
                      child: ColoredBox(
                        color: scheme.surface.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.spacing02),
            Text(
              widget.project.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: AppTypography.fontFamily,
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
                fontFamily: AppTypography.fontFamily,
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