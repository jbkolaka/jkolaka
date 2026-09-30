import 'package:flutter/material.dart';

import '../../../theme/spacing/app_spacing.dart';
import '../widget/work_list.dart';

/// Body content of the WORK section, rendered inside the shared portfolio
/// scaffold so only this portion changes when switching sections.
class WorkBody extends StatelessWidget {
  const WorkBody({super.key});

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
    return Column(
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
    );
  }
}
