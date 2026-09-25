import 'package:flutter/material.dart';

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
    return MouseRegion(
      cursor: SystemMouseCursors.none,
      onHover: (PointerEvent event) {
        setState(() => _position = event.localPosition);
      },
      onExit: (PointerEvent event) {
        setState(() => _position = null);
      },
      child: Stack(
        children: [
          widget.child,
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
        ],
      ),
    );
  }
}