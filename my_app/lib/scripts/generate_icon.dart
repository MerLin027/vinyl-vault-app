// lib/scripts/generate_icon.dart
//
// Programmatically renders the VinylVault vinyl record icon and saves it as
// two 1024×1024 PNGs consumed by flutter_launcher_icons:
//   • assets/images/app_icon.png            – regular icon (solid #111211 bg)
//   • assets/images/app_icon_foreground.png – adaptive-icon foreground (transparent bg)
//
// Run from the my_app/ directory:
//   flutter test lib/scripts/generate_icon.dart
//
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('generate vinyl app icons', () async {
    const int canvasSize = 1024;

    // Full icon: vinyl record on solid #111211 background.
    await _renderIcon(
      path: 'assets/images/app_icon.png',
      size: canvasSize,
      background: const ui.Color(0xFF111211),
      radiusFraction: 0.46, // record diameter ≈ 92 % of canvas
    );

    // Adaptive foreground: vinyl record on transparent background.
    // Smaller radius leaves safe-zone padding for the adaptive-icon crop.
    await _renderIcon(
      path: 'assets/images/app_icon_foreground.png',
      size: canvasSize,
      background: null,
      radiusFraction: 0.38, // record diameter ≈ 76 % of canvas
    );
  });
}

// ---------------------------------------------------------------------------
// Internal helpers
// ---------------------------------------------------------------------------

Future<void> _renderIcon({
  required String path,
  required int size,
  required ui.Color? background,
  required double radiusFraction,
}) async {
  final s = size.toDouble();
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder, ui.Rect.fromLTWH(0, 0, s, s));

  _drawVinyl(canvas, s, background: background, radiusFraction: radiusFraction);

  final picture = recorder.endRecording();
  final image = await picture.toImage(size, size);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

  final file = File(path);
  file.parent.createSync(recursive: true);
  await file.writeAsBytes(byteData!.buffer.asUint8List());
  // ignore: avoid_print
  print('Saved: $path (${byteData.lengthInBytes} bytes)');
}

/// Replicates the _VinylLogoPainter design from lib/widgets/vinyl_logo.dart,
/// scaled to [size] × [size] pixels with the record at [radiusFraction] of
/// the half-canvas.
///
/// Colours match the widget exactly:
///   record fill   #1A1C19   groove rings + border  #2A2D2A
///   center label  #5BAD8F   spindle hole           #111211
void _drawVinyl(
  ui.Canvas canvas,
  double size, {
  required ui.Color? background,
  required double radiusFraction,
}) {
  final center = ui.Offset(size / 2, size / 2);
  final outerRadius = size * radiusFraction;

  // Scale stroke widths proportionally to the reference 60 px widget
  // (where outerRadius = 30 px).
  final scale = outerRadius / 30.0;

  // Proportions derived from _VinylLogoPainter:
  //   labelRadius  = size.width * 0.22  →  outerRadius * 0.44
  //   spindleRadius = size.width * 0.05 →  outerRadius * 0.10
  final labelRadius = outerRadius * 0.44;
  final spindleRadius = outerRadius * 0.10;

  // ── Canvas background ────────────────────────────────────────────────────
  if (background != null) {
    canvas.drawRect(
      ui.Rect.fromLTWH(0, 0, size, size),
      ui.Paint()..color = background,
    );
  }

  // ── Outer record fill ────────────────────────────────────────────────────
  canvas.drawCircle(
    center,
    outerRadius,
    ui.Paint()..color = const ui.Color(0xFF1A1C19),
  );

  // ── Outer record border ──────────────────────────────────────────────────
  final borderWidth = 1.0 * scale;
  canvas.drawCircle(
    center,
    outerRadius - borderWidth / 2,
    ui.Paint()
      ..color = const ui.Color(0xFF2A2D2A)
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = borderWidth,
  );

  // ── Groove rings — 6 rings evenly spaced between label edge and record edge
  final groovePaint = ui.Paint()
    ..color = const ui.Color(0xFF2A2D2A)
    ..style = ui.PaintingStyle.stroke
    ..strokeWidth = 0.6 * scale;

  final grooveStart = labelRadius + 2.0 * scale;
  final grooveEnd = outerRadius - 4.0 * scale;
  final step = (grooveEnd - grooveStart) / 5.0; // 6 rings = 5 gaps
  for (int i = 0; i < 6; i++) {
    canvas.drawCircle(center, grooveStart + step * i, groovePaint);
  }

  // ── Center label circle ──────────────────────────────────────────────────
  canvas.drawCircle(
    center,
    labelRadius,
    ui.Paint()..color = const ui.Color(0xFF5BAD8F),
  );

  // ── Spindle hole ─────────────────────────────────────────────────────────
  canvas.drawCircle(
    center,
    spindleRadius,
    ui.Paint()..color = const ui.Color(0xFF111211),
  );
}
