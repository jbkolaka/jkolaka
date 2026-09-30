import 'package:flutter/material.dart';

import '../../../theme/spacing/app_spacing.dart';
import '../../../theme/typography/app_typography.dart';
import '../../../widgets/portfolio_footer.dart';
import '../widget/project_grid.dart';
import '../widget/work_list.dart';

/// Body content of the WORK section, rendered inside the shared portfolio
/// scaffold so only this portion changes when switching sections.
class WorkBody extends StatelessWidget {
  const WorkBody({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool wide = MediaQuery.sizeOf(context).width >= 1200;
    final double heroSize = wide ? 56 : 44;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.spacing06),
      children: [
        const SizedBox(height: 160),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  text: 'I\'m a mobile and backend developer ',
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: heroSize,
                    height: 1.1,
                    letterSpacing: -0.5,
                    fontWeight: FontWeight.w500,
                    color: scheme.onSurface,
                  ),
                  children: [
                    TextSpan(
                      text: 'so full stack',
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: heroSize,
                        height: 1.1,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        color: scheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Expanded(child: WorkList()),
          ],
        ),
        const SizedBox(height: AppSpacing.spacing07),
        const ProjectGrid(),
        const SizedBox(height: AppSpacing.spacing10 * 2),
        const PortfolioFooter(),
      ],
    );
  }
}
