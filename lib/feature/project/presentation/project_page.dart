import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../theme/spacing/app_spacing.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  Map<String, dynamic>? _data;
  final Map<String, Future<String>> _markdownFutures = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final String raw =
        await rootBundle.loadString(
          'lib/feature/project/data/zoa/json/zoa.json',
        );
    setState(() => _data = jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<String> _loadMarkdown(String path) =>
      _markdownFutures.putIfAbsent(path, () => rootBundle.loadString(path));

  TextStyle _inter(double size, FontWeight weight) =>
      TextStyle(fontFamily: 'Inter', fontSize: size, fontWeight: weight);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? data = _data;
    if (data == null) {
      return const Scaffold(body: SizedBox.shrink());
    }

    final List sidebar = data['sidebar'] as List;
    final Map<String, dynamic> header = data['header'] as Map<String, dynamic>;
    final List metadata = data['metadata'] as List;
    final List sections = data['sections'] as List;

    final bool isDesktop = MediaQuery.of(context).size.width >= 1000;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PROJECT'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 20,
          ),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // DYNAMIC SIDEBAR
                    Expanded(
                      flex: 2,
                      child: _buildSidebar(sidebar),
                    ),
                    const SizedBox(width: 40),
                    // DYNAMIC MAIN CONTENT
                    Expanded(
                      flex: 8,
                      child: _buildMainContent(header, metadata, sections),
                    ),
                  ],
                )
              : _buildMainContent(header, metadata, sections),
        ),
      ),
    );
  }

  Widget _buildSidebar(List sidebarItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'BACK',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 30),
        ...sidebarItems.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(
              item['title'],
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildMainContent(
    Map<String, dynamic> header,
    List metadata,
    List sections,
  ) {
    final List tags = header['tags'] as List;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // HEADER
        Row(
          children: [
            Text(
              header['projectName'],
              style: _inter(16, FontWeight.bold),
            ),
            const SizedBox(width: 10),
            Text(tags[0], style: const TextStyle(color: Colors.grey)),
            const SizedBox(width: 10),
            const Icon(Icons.star_border, size: 16, color: Colors.grey),
            const SizedBox(width: 5),
            Text(tags[1], style: const TextStyle(color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          header['title'],
          style: _inter(32, FontWeight.w400),
        ),
        const SizedBox(height: 30),

        // HERO IMAGE
        Container(
          height: 300,
          width: double.infinity,
          color: const Color(0xFFB2DFDB),
        ),
        const SizedBox(height: 20),

        // METADATA
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: metadata.map<Widget>((meta) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meta['label'],
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(meta['value'], style: const TextStyle(fontSize: 12)),
              ],
            );
          }).toList(),
        ),
        const SizedBox(height: 50),

        // DYNAMIC SECTIONS (JSON + Markdown Hybrid)
        ...sections.map<Widget>((section) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                section['label'],
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                section['title'],
                style: _inter(24, FontWeight.w400),
              ),
              const SizedBox(height: 20),

              // THE HYBRID MAGIC: FutureBuilder loads the markdown for this
              // specific section
              FutureBuilder<String>(
                future: _loadMarkdown(section['markdownFile']),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox.shrink();

                  return MarkdownBody(
                    data: snapshot.data!,
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                        height: 1.6,
                      ),
                      blockquote: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                      blockquoteDecoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(color: Colors.teal, width: 3),
                        ),
                      ),
                      strong: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  );
                },
              ),

              // Section Image
              if (section['image'] != null) ...[
                const SizedBox(height: 40),
                Container(
                  height: 250,
                  width: double.infinity,
                  color: const Color(0xFFB2DFDB),
                ),
              ],
              const SizedBox(height: AppSpacing.spacing06 * 2 + 12),
            ],
          );
        }),
      ],
    );
  }
}