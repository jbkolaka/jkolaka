import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../theme/app_palette.dart';
import '../../../theme/spacing/app_spacing.dart';

/// Documentation page for a project, styled after the ERPNext docs (frappe Wiki):
/// fixed top navbar + breadcrumbs, a left navigation tree, a centred content
/// column and a "On this page" right rail that tracks the scroll position.
class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  static const double _railWidth = 240;
  static const double _tocWidth = 200;
  static const double _contentMaxWidth = 720;

  Map<String, dynamic>? _data;
  final Map<String, Future<String>> _markdownFutures = {};

  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = [];
  int _activeSection = -1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _load();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final String raw =
        await rootBundle.loadString(
          'lib/feature/project/data/zoa/json/zoa.json',
        );
    final Map<String, dynamic> data = jsonDecode(raw) as Map<String, dynamic>;
    _sectionKeys
      ..clear()
      ..addAll(
        List.generate((data['sections'] as List).length, (_) => GlobalKey()),
      );
    setState(() => _data = data);
  }

  Future<String> _loadMarkdown(String path) =>
      _markdownFutures.putIfAbsent(path, () => rootBundle.loadString(path));

  void _onScroll() {
    final List<GlobalKey> keys = [..._sectionKeys];
    int active = -1;
    for (int i = 0; i < keys.length; i++) {
      final RenderBox? box = keys[i].currentContext?.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final double top = box.localToGlobal(Offset.zero).dy;
      if (top <= _tocActiveTarget) {
        active = i;
      } else {
        break;
      }
    }
    if (active != _activeSection) {
      setState(() => _activeSection = active);
    }
  }

  double get _tocActiveTarget =>
      MediaQuery.of(context).padding.top +
      _headerHeight +
      AppSpacing.spacing05;

  static const double _headerHeight = 56;

  void _scrollToSection(int index) {
    final RenderBox? box = _sectionKeys[index].currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final double top = box.localToGlobal(Offset.zero).dy;
    _scrollController.animateTo(
      _scrollController.offset + top - _tocActiveTarget,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
    setState(() => _activeSection = index);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? data = _data;
    if (data == null) {
      return const Scaffold(body: SizedBox.shrink());
    }

    final bool isDesktop = MediaQuery.of(context).size.width >= 1000;
    final ZoaPalette palette = context.palette;

    return Scaffold(
      backgroundColor: palette.background,
      body: Column(
        children: [
          _DocsHeader(onBack: () => Navigator.of(context).maybePop()),
          Expanded(
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSidebar(data),
                      VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: palette.borderSubtle,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: _contentMaxWidth,
                              ),
                              child: _buildContent(data),
                            ),
                          ),
                        ),
                      ),
                      VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: palette.borderSubtle,
                      ),
                      _buildOnThisPage(data),
                    ],
                  )
                : SingleChildScrollView(
                    controller: _scrollController,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: _contentMaxWidth,
                        ),
                        child: _buildContent(data),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Sidebar + "On this page"
  // ---------------------------------------------------------------------------

  Widget _buildSidebar(Map<String, dynamic> data) {
    final ZoaPalette palette = context.palette;
    final List sidebar = data['sidebar'] as List;

    return Container(
      width: _railWidth,
      color: palette.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing05,
          vertical: AppSpacing.spacing06,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RailGroupLabel('Getting Started'),
            const SizedBox(height: AppSpacing.spacing02),
            ...List.generate(sidebar.length, (i) {
              final Map item = sidebar[i] as Map;
              final String id = (item['id'] ?? '') as String;
              final int sectionIndex = _indexForId(id);
              final bool active = i == _activeSection;
              return _RailItem(
                title: item['title'] as String,
                active: active,
                onTap: sectionIndex >= 0
                    ? () => _scrollToSection(sectionIndex)
                    : null,
              );
            }),
            const SizedBox(height: AppSpacing.spacing07),
            _RailGroupLabel('Resources'),
            const SizedBox(height: AppSpacing.spacing02),
            const _RailItem(title: 'GitHub', onTap: null),
            const _RailItem(title: 'Case Study', onTap: null),
          ],
        ),
      ),
    );
  }

  int _indexForId(String id) {
    final List sections = (_data!['sections'] as List);
    for (int i = 0; i < sections.length; i++) {
      if ((sections[i] as Map)['id'] == id) return i;
    }
    return -1;
  }

  Widget _buildOnThisPage(Map<String, dynamic> data) {
    final ZoaPalette palette = context.palette;
    final List sections = data['sections'] as List;

    return Container(
      width: _tocWidth,
      color: palette.background,
      padding: const EdgeInsets.only(
        top: AppSpacing.spacing06,
        bottom: AppSpacing.spacing06,
        left: AppSpacing.spacing05,
        right: AppSpacing.spacing04,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'On this page',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: palette.textSecondary,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: AppSpacing.spacing04),
          ...List.generate(sections.length, (i) {
            final Map section = sections[i] as Map;
            final bool active = i == _activeSection;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.spacing03),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.button),
                onTap: () => _scrollToSection(i),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.spacing01,
                    horizontal: AppSpacing.spacing03,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 2,
                        height: 14,
                        margin: const EdgeInsets.only(top: 2, right: 8),
                        color: active ? palette.link : Colors.transparent,
                      ),
                      Expanded(
                        child: Text(
                          section['title'] as String,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.3,
                            fontFamily: 'Inter',
                            color: active
                                ? palette.link
                                : palette.textSecondary,
                            fontWeight: active
                                ? FontWeight.w500
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildContent(Map<String, dynamic> data) {
    final Map<String, dynamic> header = data['header'] as Map<String, dynamic>;
    final List metadata = data['metadata'] as List;
    final List sections = data['sections'] as List;
    final List tags = header['tags'] as List;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacing07,
        vertical: AppSpacing.spacing07,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBreadcrumbs(header['projectName'] as String),
          const SizedBox(height: AppSpacing.spacing07),
          Text(
            header['title'] as String,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 34,
              height: 1.2,
              fontWeight: FontWeight.w600,
              color: context.palette.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.spacing05),
          Wrap(
            spacing: AppSpacing.spacing03,
            runSpacing: AppSpacing.spacing03,
            children: [
              for (final String tag in tags.cast<String>())
                _buildTag(tag),
            ],
          ),
          const SizedBox(height: AppSpacing.spacing07),

          // HERO IMAGE
          Container(
            height: 280,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: context.palette.borderSubtle),
            ),
            child: const ColoredBox(color: Color(0xFFB2DFDB)),
          ),
          const SizedBox(height: AppSpacing.spacing07),

          // METADATA
          _buildMetadata(metadata),
          const SizedBox(height: AppSpacing.spacing09),

          // SECTIONS
          ...List.generate(sections.length, (i) {
            final Map section = sections[i] as Map;
            return _buildSection(i, section);
          }),

          const SizedBox(height: AppSpacing.spacing07),
          _buildWasHelpful(),
        ],
      ),
    );
  }

  Widget _buildBreadcrumbs(String projectName) {
    final ZoaPalette palette = context.palette;
    const TextStyle link = TextStyle(
      fontFamily: 'Inter',
      fontSize: 13,
      fontWeight: FontWeight.w500,
    );
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.spacing02,
      children: [
        InkWell(
          onTap: () => Navigator.of(context).maybePop(),
          child: Text(
            'Docs',
            style: link.copyWith(color: palette.link),
          ),
        ),
        _breadcrumbSeparator(palette),
        Text(
          projectName,
          style: link.copyWith(color: palette.textPrimary),
        ),
        _breadcrumbSeparator(palette),
        Text(
          'Overview',
          style: link.copyWith(color: palette.textSecondary),
        ),
      ],
    );
  }

  Widget _breadcrumbSeparator(ZoaPalette palette) {
    return Icon(
      Icons.chevron_right,
      size: 16,
      color: palette.textSecondary,
    );
  }

  Widget _buildTag(String tag) {
    final ZoaPalette palette = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacing03,
        vertical: AppSpacing.spacing02,
      ),
      decoration: BoxDecoration(
        color: palette.accent,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        tag,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: palette.textSecondary,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildMetadata(List metadata) {
    final ZoaPalette palette = context.palette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacing05,
        vertical: AppSpacing.spacing05,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: palette.borderSubtle),
        borderRadius: BorderRadius.circular(AppRadius.field),
        color: palette.surfaceMuted,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final int columns =
              constraints.maxWidth >= 520 ? 4 : 2;
          final int rows = (metadata.length / columns).ceil();
          return Column(
            children: [
              for (var r = 0; r < rows; r++)
                Row(
                  children: [
                    for (var c = 0; c < columns; c++)
                      Expanded(
                        child: _buildMetaCell(metadata[r * columns + c]),
                      ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMetaCell(Map meta) {
    final ZoaPalette palette = context.palette;
    final String value = (meta['value'] as String).replaceAll('\n', ' ');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacing02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            meta['label'] as String,
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 1.1,
              color: palette.textSecondary,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: AppSpacing.spacing02),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: palette.textPrimary,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(int index, Map section) {
    final ZoaPalette palette = context.palette;
    return Column(
      key: _sectionKeys[index],
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          (section['label'] as String).toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 1.4,
            color: palette.textSecondary,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: AppSpacing.spacing03),
        Text(
          section['title'] as String,
          style: TextStyle(
            fontSize: 22,
            height: 1.3,
            fontWeight: FontWeight.w500,
            color: palette.textPrimary,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: AppSpacing.spacing05),
        FutureBuilder<String>(
          future: _loadMarkdown(section['markdownFile'] as String),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            return MarkdownBody(
              data: snapshot.data!,
              styleSheet: _markdownStyle(palette),
            );
          },
        ),
        if (section['image'] != null) ...[
          const SizedBox(height: AppSpacing.spacing07),
          Container(
            height: 240,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: palette.borderSubtle),
            ),
            child: const ColoredBox(color: Color(0xFFB2DFDB)),
          ),
        ],
        if (index < (_data!['sections'] as List).length - 1)
          Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.spacing08,
              bottom: AppSpacing.spacing08,
            ),
            child: Divider(height: 1, color: palette.borderSubtle),
          ),
      ],
    );
  }

  MarkdownStyleSheet _markdownStyle(ZoaPalette palette) {
    return MarkdownStyleSheet(
      p: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        height: 1.75,
        color: palette.textPrimary,
      ),
      strong: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: palette.textPrimary,
      ),
      listBullet: TextStyle(
        color: palette.textSecondary,
        fontSize: 16,
        height: 1.75,
      ),
      pPadding: const EdgeInsets.only(bottom: AppSpacing.spacing04),
      listIndent: AppSpacing.spacing06,
      blockquote: TextStyle(
        fontFamily: 'Inter',
        fontSize: 15,
        height: 1.6,
        color: palette.textSecondary,
      ),
      blockquoteDecoration: BoxDecoration(
        color: palette.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.field),
        border: Border(
          left: BorderSide(color: palette.link, width: 3),
        ),
      ),
      blockquotePadding: const EdgeInsets.fromLTRB(
        AppSpacing.spacing05,
        AppSpacing.spacing04,
        AppSpacing.spacing05,
        AppSpacing.spacing04,
      ),
      h2: _markdownHeading(22, palette),
      h3: _markdownHeading(18, palette),
      h4: _markdownHeading(16, palette),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(top: BorderSide(color: palette.borderSubtle)),
      ),
    );
  }

  TextStyle _markdownHeading(double size, ZoaPalette palette) => TextStyle(
        fontFamily: 'Inter',
        fontSize: size,
        height: 1.3,
        fontWeight: FontWeight.w600,
        color: palette.textPrimary,
      );

  Widget _buildWasHelpful() {
    final ZoaPalette palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(height: 1, color: palette.borderSubtle),
        const SizedBox(height: AppSpacing.spacing07),
        Text(
          'Was this page helpful?',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: palette.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.spacing05),
        Row(
          children: [
            _HelpButton(
              icon: Icons.thumb_up_outlined,
              label: 'Yes',
              onTap: () => _thanks('Thanks for your feedback!'),
            ),
            const SizedBox(width: AppSpacing.spacing04),
            _HelpButton(
              icon: Icons.thumb_down_outlined,
              label: 'No',
              onTap: () => _thanks('Thanks — we will work on this page.'),
            ),
          ],
        ),
      ],
    );
  }

  void _thanks(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

// ---------------------------------------------------------------------------
// Local helpers (private widgets)
// ---------------------------------------------------------------------------

class _DocsHeader extends StatelessWidget {
  const _DocsHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final ZoaPalette palette = context.palette;
    return Container(
      height: _ProjectPageState._headerHeight,
      decoration: BoxDecoration(
        color: palette.background,
        border: Border(
          bottom: BorderSide(color: palette.borderSubtle),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing05),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: Icon(Icons.arrow_back, size: 18, color: palette.textPrimary),
            tooltip: 'Back',
          ),
          const SizedBox(width: AppSpacing.spacing02),
          Text(
            'Zoa Docs',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: palette.textPrimary,
            ),
          ),
          const Spacer(),
          Icon(Icons.search, size: 18, color: palette.textSecondary),
          const SizedBox(width: AppSpacing.spacing05),
          Icon(Icons.nightlight_outlined, size: 18, color: palette.textSecondary),
          const SizedBox(width: AppSpacing.spacing05),
          Icon(Icons.code, size: 18, color: palette.textSecondary),
        ],
      ),
    );
  }
}

class _RailGroupLabel extends StatelessWidget {
  const _RailGroupLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        color: context.palette.textSecondary,
      ),
    );
  }
}

class _RailItem extends StatelessWidget {
  const _RailItem({required this.title, this.active = false, this.onTap});

  final String title;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ZoaPalette palette = context.palette;
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.button),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: active ? palette.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing04,
          vertical: AppSpacing.spacing04 * 0.9,
        ),
        child: Row(
          children: [
            if (active) ...[
              Container(
                width: 3,
                height: 14,
                decoration: BoxDecoration(
                  color: palette.link,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppSpacing.spacing03),
            ],
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  color: active ? palette.link : palette.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HelpButton extends StatelessWidget {
  const _HelpButton({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ZoaPalette palette = context.palette;
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: palette.textPrimary,
        side: BorderSide(color: palette.border),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing05,
          vertical: AppSpacing.spacing04,
        ),
        minimumSize: Size.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}