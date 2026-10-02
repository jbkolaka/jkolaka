import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../theme/spacing/app_spacing.dart';
import '../../../theme/typography/app_typography.dart';
import '../../../widgets/app_links.dart';
import '../data/work_model.dart';

/// Career timeline in Rachel Chen's style: each entry is a mono, muted year
/// followed by the company (shifts to primary on hover) and the role. Stacked
/// below 1200px, side by side above, mirroring her breakpoints.
class WorkList extends StatefulWidget {
  const WorkList({super.key});

  @override
  State<WorkList> createState() => _WorkListState();
}

class _WorkListState extends State<WorkList> {
  List<WorkExperience>? _items;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final String raw = await rootBundle.loadString(
      'lib/feature/work/data/work.json',
    );
    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
    final List<WorkExperience> items = decoded
        .map((e) => WorkExperience.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.year.compareTo(a.year));
    setState(() => _items = items);
  }

  @override
  Widget build(BuildContext context) {
    final List<WorkExperience>? items = _items;
    if (items == null) {
      return const SizedBox.shrink();
    }

    final bool wide = MediaQuery.sizeOf(context).width >= 1200;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.spacing03),
          _TimelineRow(item: items[i], wide: wide),
        ],
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.item, required this.wide});

  final WorkExperience item;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Widget year = SizedBox(
      width: 104,
      child: Text(
        '${item.year}',
        style: const TextStyle(
          fontFamily: AppTypography.monoFontFamily,
          fontSize: 15,
          height: 1.3,
        ),
      ),
    );
    final Widget company = _CompanyLink(
      name: item.company,
      url: item.url,
    );
    final Widget role = Text(
      item.role,
      maxLines: wide ? 1 : 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 15,
        height: 1.3,
        color: scheme.onSurfaceVariant,
      ),
    );

    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          year,
          const SizedBox(width: AppSpacing.spacing02),
          SizedBox(width: 224, child: company),
          const SizedBox(width: AppSpacing.spacing02),
          Expanded(child: role),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        year,
        const SizedBox(width: AppSpacing.spacing02),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              company,
              const SizedBox(height: AppSpacing.spacing01),
              role,
            ],
          ),
        ),
      ],
    );
  }
}

class _CompanyLink extends StatefulWidget {
  const _CompanyLink({required this.name, required this.url});

  final String name;
  final String url;

  @override
  State<_CompanyLink> createState() => _CompanyLinkState();
}

class _CompanyLinkState extends State<_CompanyLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool linked = widget.url.isNotEmpty;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: linked ? () => AppLinks.open(context, widget.url) : null,
        behavior: HitTestBehavior.opaque,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: 15,
            height: 1.3,
            color: _hovered ? scheme.primary : scheme.onSurface,
          ),
          child: Text(
            widget.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}