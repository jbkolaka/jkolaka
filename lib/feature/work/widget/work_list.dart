import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../theme/spacing/app_spacing.dart';
import '../data/work_model.dart';

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

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.spacing02),
      itemBuilder: (context, index) {
        final WorkExperience item = items[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text('${item.year}', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(width: AppSpacing.spacing04),
            Expanded(
              child: Text(
                item.company,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            Flexible(
              child: Text(
                item.role,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        );
      },
    );
  }
}
