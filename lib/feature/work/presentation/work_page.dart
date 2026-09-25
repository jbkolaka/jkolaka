import 'package:flutter/material.dart';

import '../../../theme/spacing/app_spacing.dart';
import '../widget/work_list.dart';

class WorkPage extends StatelessWidget {
  const WorkPage({super.key});

  static const List<Color> _gridColors = [
    Color(0xFF0F62FE),
    Color(0xFFEE5396),
    Color(0xFF6FDD8B),
    Color(0xFFFF832B),
    Color(0xFF8A3FFC),
    Color(0xFFF1C21B),
    Color(0xFF4589FF),
    Color(0xFFD12771),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    'JOE KOLAKA',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: AppSpacing.spacing03),
                  Flexible(
                    child: Text(
                      'MOBILE DEVELOPER',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spacing03),
                  const Text('*'),
                  const SizedBox(width: AppSpacing.spacing03),
                  Flexible(
                    child: Text(
                      'GO BACKEND DEVELOPER',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      'WORK',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spacing03),
                  Flexible(
                    child: Text(
                      'HACKATHONS',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spacing03),
                  Flexible(
                    child: Text(
                      'RESUME',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const Divider(height: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.spacing06),
              child: ListView(
              padding: const EdgeInsets.all(AppSpacing.spacing06),
              children: [
                const SizedBox(height: AppSpacing.spacing10 * 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'I\'m a mobile and backend developer \nso full stack',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    const Expanded(child: WorkList()),
                  ],
                ),
                const SizedBox(height: AppSpacing.spacing06),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.spacing04,
                  crossAxisSpacing: AppSpacing.spacing04,
children: [
                        for (int i = 0; i < 8; i++)
                          InkWell(
                            onTap: () =>
                                Navigator.pushNamed(context, '/project'),
                            borderRadius: BorderRadius.circular(AppRadius.card),
                            child: Container(
                              decoration: BoxDecoration(
                                color: _gridColors[i % _gridColors.length],
                                borderRadius: BorderRadius.circular(
                                  AppRadius.card,
                                ),
                              ),
                            ),
                          ),
                      ],
                ),
              ],
            ),
            ),
          ),
        ],
      ),
    );
  }
}
