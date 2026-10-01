import 'package:flutter/material.dart';

import '../../../theme/spacing/app_spacing.dart';
import '../../../theme/typography/app_typography.dart';
import '../../../widgets/portfolio_footer.dart';
import '../widget/hackathon_grid.dart';

/// Body content of the HACKATHONS section: an intro hero and a grid of
/// hackathon cards above the shared footer, rendered inside the same shell.
class HackathonsBody extends StatelessWidget {
  const HackathonsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool wide = MediaQuery.sizeOf(context).width >= 1200;
    final double heroSize = wide ? 56 : 44;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.spacing06),
      children: [
        const SizedBox(height: AppSpacing.spacing09),
        Text.rich(
          TextSpan(
            text: 'Hackathons & ',
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
                text: 'silly little side quests.',
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
        const SizedBox(height: AppSpacing.spacing07),
        Text(
          'When I\'m not building product, I\'m joining hackathons and '
          'turning half-baked ideas into working prototypes.',
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: 15,
            height: 1.5,
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.spacing07),
        const HackathonGrid(),
        const SizedBox(height: AppSpacing.spacing10 * 2),
        const PortfolioFooter(),
      ],
    );
  }
}