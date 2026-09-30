import 'package:flutter/material.dart';

import '../theme/spacing/app_spacing.dart';

/// Which top-level section is currently shown. Drives the nav-bar links.
enum PortfolioSection { work, hackathons }

/// Shared portfolio chrome — brand row plus WORK / HACKATHONS / RESUME links.
/// The active section stays primary; others shift to primary on hover, with
/// no button background (Rachel Chen style).
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
    final ColorScheme scheme = Theme.of(context).colorScheme;
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
                Flexible(
                  child: _NavLink(
                    label: 'WORK',
                    active: current == PortfolioSection.work,
                    onTap: () => onSectionSelected(PortfolioSection.work),
                  ),
                ),
                const SizedBox(width: AppSpacing.spacing04),
                Flexible(
                  child: _NavLink(
                    label: 'HACKATHONS',
                    active: current == PortfolioSection.hackathons,
                    onTap: () =>
                        onSectionSelected(PortfolioSection.hackathons),
                  ),
                ),
                const SizedBox(width: AppSpacing.spacing04),
                Flexible(child: _NavLink(label: 'RESUME', onTap: () {})),
              ],
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          height: 1,
          thickness: 1,
          color: scheme.outlineVariant,
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({required this.label, this.active = false, this.onTap});

  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color baseColor = scheme.onSurfaceVariant;
    final Color color = widget.active || _hovered
        ? scheme.primary
        : baseColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
            color: color,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}