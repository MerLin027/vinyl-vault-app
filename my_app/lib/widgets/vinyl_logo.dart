import 'package:flutter/material.dart';

import '../config/theme.dart';

class VinylLogo extends StatelessWidget {
  const VinylLogo({super.key, this.size = 60.0});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _VinylLogoPainter(),
      ),
    );
  }
}

class _VinylLogoPainter extends CustomPainter {
  const _VinylLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final labelRadius = size.width * 0.22;
    final spindleRadius = size.width * 0.05;

    // ── Outer record fill ───────────────────────────────────────────────────
    canvas.drawCircle(
      center,
      outerRadius,
      Paint()..color = const Color(0xFF1A1C19),
    );

    // ── Outer record border ─────────────────────────────────────────────────
    canvas.drawCircle(
      center,
      outerRadius - 0.5,
      Paint()
        ..color = const Color(0xFF2A2D2A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // ── Groove rings — 6 evenly spaced between edge and label ──────────────
    final groovePaint = Paint()
      ..color = const Color(0xFF2A2D2A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    final grooveStart = labelRadius + 2;
    final grooveEnd = outerRadius - 4;
    final step = (grooveEnd - grooveStart) / 5; // 6 rings = 5 gaps
    for (int i = 0; i < 6; i++) {
      canvas.drawCircle(center, grooveStart + step * i, groovePaint);
    }

    // ── Center label circle ─────────────────────────────────────────────────
    canvas.drawCircle(
      center,
      labelRadius,
      Paint()..color = AppColors.accent,
    );

    // ── Spindle hole ────────────────────────────────────────────────────────
    canvas.drawCircle(
      center,
      spindleRadius,
      Paint()..color = const Color(0xFF111211),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
