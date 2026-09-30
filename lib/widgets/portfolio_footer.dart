import 'package:flutter/material.dart';

import '../theme/spacing/app_spacing.dart';

/// Rachel Chen-style footer: a bordered strip with "Designed + Coded with ♥"
/// on the left and social links on the right. Links shift to primary on hover.
class PortfolioFooter extends StatelessWidget {
  const PortfolioFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacing06,
        vertical: AppSpacing.spacing05,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      child: const Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: AppSpacing.spacing04,
        spacing: AppSpacing.spacing06,
        children: [
          _Signature(),
          _SocialLinks(),
        ],
      ),
    );
  }
}

class _Signature extends StatefulWidget {
  const _Signature();

  @override
  State<_Signature> createState() => _SignatureState();
}

class _SignatureState extends State<_Signature> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.spacing02,
      children: [
        const Text(
          'Designed + Coded with',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: AnimatedScale(
            scale: _hovered ? 1.2 : 1,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: Icon(
              Icons.favorite,
              size: 15,
              color: _hovered ? scheme.primary : scheme.onSurfaceVariant,
            ),
          ),
        ),
        const Text(
          'by Joe Kolaka',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _SocialLinks extends StatelessWidget {
  const _SocialLinks();

  static const List<String> _labels = [
    'Linkedin',
    'EMAIL',
    'X',
    'Github',
    'Devpost',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.spacing07,
      runSpacing: AppSpacing.spacing03,
      children: [
        for (final label in _labels) _FooterLink(label: label),
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  const _FooterLink({required this.label});

  final String label;

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {},
        behavior: HitTestBehavior.opaque,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: _hovered ? scheme.primary : scheme.onSurfaceVariant,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}