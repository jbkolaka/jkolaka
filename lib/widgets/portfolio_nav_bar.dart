import 'package:flutter/material.dart';

import '../theme/spacing/app_spacing.dart';

/// Which top-level section is currently shown. Drives the nav-bar buttons.
enum PortfolioSection { work, hackathons }

/// Shared portfolio chrome — brand row plus WORK / HACKATHONS / RESUME nav.
/// Only [current] changes the page; the parent decides what body to show.
class PortfolioNavBar extends StatelessWidget implements PreferredSizeWidget {
  const PortfolioNavBar({
    super.key,
    required this.current,
    required this.onSectionSelected,
  });

  final PortfolioSection current;
  final ValueChanged<PortfolioSection> onSectionSelected;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Text('JOE KOLAKA', style: textTheme.bodySmall),
                const SizedBox(width: AppSpacing.spacing03),
                Flexible(
                  child: Text(
                    'MOBILE DEVELOPER',
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall,
                  ),
                ),
                const SizedBox(width: AppSpacing.spacing03),
                const Text('*'),
                const SizedBox(width: AppSpacing.spacing03),
                Flexible(
                  child: Text(
                    'GO BACKEND DEVELOPER',
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                for (final (section, label) in [
                  (PortfolioSection.work, 'WORK'),
                  (PortfolioSection.hackathons, 'HACKATHONS'),
                  (null, 'RESUME'),
                ]) ...[
                  Flexible(
                    child: TextButton(
                      onPressed: section == null
                          ? () {}
                          : () => onSectionSelected(section),
                      child: Text(label),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spacing03),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}