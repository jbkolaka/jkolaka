import 'package:flutter/material.dart';

import '../../../theme/typography/app_typography.dart';

/// Hover label shown inside the custom cursor pill (Rachel Chen-style).
/// Set by widgets that want the cursor to expand with text, e.g. project
/// cards; the [CirclePointer] overlay listens and renders the pill.
final ValueNotifier<String?> cursorLabel = ValueNotifier<String?>(null);

/// Small custom cursor: a primary-coloured dot that morphs into a labelled
/// pill ("View Project", …) when hovering special targets.
class CirclePointer extends StatefulWidget {
  const CirclePointer({super.key, required this.child});

  final Widget child;

  @override
  State<CirclePointer> createState() => _CirclePointerState();
}

class _CirclePointerState extends State<CirclePointer> {
  static const double _eye = 8;

  Offset? _position;

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;
    return Stack(
      children: [
        widget.child,
        MouseRegion(
          opaque: false,
          cursor: SystemMouseCursors.none,
          onHover: (PointerEvent event) {
            setState(() => _position = event.localPosition);
          },
          onExit: (PointerEvent event) {
            setState(() => _position = null);
          },
          child: const SizedBox.expand(),
        ),
        if (_position != null)
          Positioned(
            left: _position!.dx - _eye,
            top: _position!.dy - _eye,
            child: IgnorePointer(
              child: Container(
                width: _eye * 2,
                height: _eye * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primary.withValues(alpha: 0.8),
                  border: Border.all(color: primary, width: 2),
                ),
              ),
            ),
          ),
        if (_position != null)
          Positioned(
            left: _position!.dx + AppSpacingPill.gap,
            top: _position!.dy - AppSpacingPill.halfHeight,
            child: IgnorePointer(
              child: ValueListenableBuilder<String?>(
                valueListenable: cursorLabel,
                builder: (context, label, _) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    reverseDuration: const Duration(milliseconds: 150),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.85, end: 1).animate(
                            animation,
                          ),
                          child: child,
                        ),
                      );
                    },
                    child: label == null
                        ? const SizedBox(
                            key: ValueKey('none'),
                            width: 0,
                            height: 0,
                          )
                        : AnimatedScale(
                            key: ValueKey(label),
                            scale: 1,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOutCubic,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: primary,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                label.toUpperCase(),
                                style: const TextStyle(
                                  fontFamily: AppTypography.monoFontFamily,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.6,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

/// Layout constants shared between the cursor dot and its pill.
class AppSpacingPill {
  const AppSpacingPill._();

  /// Gap between the dot and the pill.
  static const double gap = 12;

  /// Half the pill height, used to keep it vertically centred on the dot.
  static const double halfHeight = 13;
}